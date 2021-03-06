defmodule Doit.NotificationPipeline do
  @moduledoc "Gets notifications from Github and sends them to Todoist"
  use GenServer
  require Logger

  alias Doit.{GitHub, Todoist}
  alias Doit.GitHub.{Notification, Response}

  if Mix.env() === :test do
    @short_delay 1
    @todoist_delay_per_task 1
    @delay_on_failure 1
    defp set_interval(_interval), do: 100
  else
    @short_delay 500
    @todoist_delay_per_task 5000
    @delay_on_failure 120_000
    defp set_interval(interval), do: interval
  end

  # Client

  @spec start_link(any) :: {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_state) do
    Process.send_after(__MODULE__, :process, @short_delay, [])
    {:ok, %{interval: @short_delay * 2, tasks: [], timestamp: nil}}
  end

  @impl true
  # Notifications have been marked as read on GitHub, so trigger fetch
  def handle_info(:process, %{tasks: [], interval: interval, timestamp: nil} = state) do
    Process.send_after(__MODULE__, :fetch, interval, [])
    {:noreply, state}
  end

  @impl true
  # Tasks have all been processed, but notifications have not been cleared yet
  def handle_info(:process, %{tasks: [], interval: interval, timestamp: timestamp} = state) do
    case GitHub.clear_notifications(timestamp) do
      :ok ->
        Logger.info("Cleared GitHub notifications after timestamp: #{timestamp}")
        Process.send_after(__MODULE__, :process, @short_delay, [])
        {:noreply, Map.put(state, :timestamp, nil)}

      response ->
        Logger.warn("Failed to clear GitHub notifications: #{inspect(response)}")
        Process.send_after(__MODULE__, :process, interval * 2, [])
        {:noreply, state}
    end
  end

  @impl true
  # There are more tasks to process
  def handle_info(:process, %{tasks: [head | tail]} = state) do
    case Todoist.create_task(head) do
      :ok ->
        Logger.info("Created Todoist task: #{inspect(head)}")
        Process.send_after(__MODULE__, :process, @todoist_delay_per_task, [])
        {:noreply, Map.put(state, :tasks, tail)}

      response ->
        Logger.warn("Failed to create Todoist task: #{inspect(response)}")
        Process.send_after(__MODULE__, :process, @delay_on_failure, [])
        {:noreply, state}
    end
  end

  @impl true
  # Fetch more tasks from the GitHub API
  def handle_info(:fetch, state) do
    case fetch_tasks() do
      {:ok,
       %{
         num_tasks: num_tasks,
         num_filtered_tasks: num_filtered_tasks,
         filtered_tasks: filtered_tasks,
         timestamp: timestamp,
         interval: interval
       }} ->
        Logger.info(
          "Fetched #{num_tasks}, removed #{num_tasks - num_filtered_tasks}, #{num_filtered_tasks} remaining"
        )

        Process.send_after(__MODULE__, :process, @short_delay, [])

        {:noreply,
         %{interval: set_interval(interval), tasks: filtered_tasks, timestamp: timestamp}}

      response ->
        Logger.warn("Failed to generate new tasks: #{inspect(response)}")
        Process.send_after(__MODULE__, :fetch, @delay_on_failure, [])
        {:noreply, state}
    end
  end

  defp fetch_tasks do
    with {:ok,
          %Response{poll_interval: interval, timestamp: timestamp, notifications: notifications}} <-
           GitHub.get_notifications(),
         notifications <- Enum.filter(notifications, &not_merged/1),
         tasks <- Enum.map(notifications, &GitHub.task_from_notification/1),
         tasks <- Enum.map(tasks, &Todoist.task_to_command(%{task: &1})),
         {:ok, current_task_content} <- Todoist.current_task_content(),
         filtered_tasks <- Todoist.filter_existing_tasks(tasks, current_task_content) do
      num_tasks = Enum.count(tasks)
      num_filtered_tasks = Enum.count(filtered_tasks)
      timestamp = if Enum.empty?(filtered_tasks), do: nil, else: timestamp

      {:ok,
       %{
         num_tasks: num_tasks,
         num_filtered_tasks: num_filtered_tasks,
         filtered_tasks: filtered_tasks,
         timestamp: timestamp,
         interval: interval
       }}
    end
  end

  defp not_merged(%Notification{url: url}) do
    case GitHub.pull_merge_status(url) do
      {:ok, :merged} -> false
      {:ok, :open} -> true
    end
  end
end
