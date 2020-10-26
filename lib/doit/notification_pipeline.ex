defmodule Doit.NotificationPipeline do
  @moduledoc "Gets notifications from Github and sends them to Todoist"
  use GenServer
  require Logger

  alias Doit.{GitHub, Todoist}
  alias Doit.GitHub.Response

  @short_delay 500
  @todoist_delay_per_task 5000
  @delay_on_failure 120_000

  # Client

  @spec start_link(any) :: {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_state) do
    Process.send_after(__MODULE__, :process, @short_delay, [])
    {:ok, %{interval: 1000, tasks: [], timestamp: nil}}
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
    with {:ok, %Response{} = response} <- GitHub.get_notifications(),
         %Response{poll_interval: interval, timestamp: timestamp} <- response,
         tasks <- GitHub.tasks_from_response(response),
         tasks <- Enum.map(tasks, &Todoist.task_to_command(%{task: &1})) do
      Logger.info("Fetched #{Enum.count(tasks)} tasks from GitHub")
      Process.send_after(__MODULE__, :process, @short_delay, [])

      timestamp = if Enum.empty?(tasks), do: nil, else: timestamp
      {:noreply, %{interval: interval, tasks: tasks, timestamp: timestamp}}
    else
      response ->
        Logger.warn("Failed to fetch tasks from GitHub: #{inspect(response)}")
        Process.send_after(__MODULE__, :fetch, @delay_on_failure, [])
        {:noreply, state}
    end
  end
end
