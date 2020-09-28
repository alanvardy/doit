defmodule Doit.Processor do
  @moduledoc "Gets notifications from Github and sends them to Todoist"
  use GenServer

  alias Doit.{GitHub, Todoist}
  alias Doit.GitHub.Response

  # Client

  @spec start_link(any) :: {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_state) do
    Process.send_after(__MODULE__, :process, 100, [])
    {:ok, %{interval: 1000, tasks: []}}
  end

  @impl true
  def handle_info(:process, %{tasks: [], interval: interval} = state) do
    Process.send_after(__MODULE__, :fetch, interval, [])
    {:noreply, state}
  end

  def handle_info(:process, %{tasks: [head | tail]} = state) do
    case Todoist.create_task(head) do
      :ok ->
        Process.send_after(__MODULE__, :process, 5000, [])
        {:noreply, Map.put(state, :tasks, tail)}

      _ ->
        Process.send_after(__MODULE__, :process, 30_000, [])
        {:noreply, state}
    end
  end

  def handle_info(:fetch, state) do
    with {:ok, %Response{} = response} <- GitHub.get_notifications(),
         %Response{poll_interval: interval} <- response,
         tasks <- GitHub.tasks_from_response(response) do
      Process.send_after(__MODULE__, :process, 1000, [])
      {:noreply, %{interval: interval, tasks: tasks}}
    else
      _ ->
        Process.send_after(__MODULE__, :fetch, 60_000, [])
        {:noreply, state}
    end
  end
end
