defmodule Doit.PeriodicJob do
  @moduledoc "Runs periodic jobs that are not time sensitive"
  use GenServer
  require Logger

  alias Doit.Todoist

  @five_seconds :timer.seconds(5)
  @five_minutes :timer.minutes(5)
  @fifteen_minutes :timer.minutes(15)

  # Client

  @spec start_link(keyword) :: {:ok, pid}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  @spec init(keyword) :: {:ok, any}
  def init(opts) do
    loop(50)
    {:ok, %{tasks: [], opts: opts}}
  end

  @impl true
  def handle_info(:run, %{tasks: [head | tail] = tasks, opts: opts}) do
    tasks =
      case Todoist.create_task(head, opts) do
        :ok -> tail
        _ -> tasks
      end

    loop(@five_seconds)
    {:noreply, %{tasks: tasks, opts: opts}}
  end

  def handle_info(:run, %{tasks: [], opts: opts}) do
    tasks =
      cond do
        Todoist.time_to_send_weekly_summary?(opts) -> get_completed_tasks(:last_week, opts)
        Todoist.time_to_send_daily_summary?(opts) -> get_completed_tasks(:last_24, opts)
        true -> get_completed_tasks(:none, opts)
      end

    {:noreply, %{tasks: tasks, opts: opts}}
  end

  defp loop(delay) do
    delay =
      case Application.get_env(:doit, :env) do
        :test -> 50
        _ -> delay
      end

    Process.send_after(__MODULE__, :run, delay, [])
  end

  defp get_completed_tasks(:none, _opts) do
    loop(@fifteen_minutes)
    []
  end

  defp get_completed_tasks(period, opts) do
    case Todoist.get_completed_tasks(period, opts) do
      {:ok, tasks} ->
        loop(@five_seconds)
        tasks

      error ->
        Logger.error("Cannot send completed task. Period: #{period}, error: #{inspect(error)}")
        loop(@five_minutes)
        []
    end
  end
end
