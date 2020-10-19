defmodule Doit.PeriodicJob do
  @moduledoc "Runs periodic jobs that are not time sensitive"
  use GenServer
  require Logger

  alias Doit.Todoist

  @one_minute :timer.minutes(1)
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
    {:ok, opts}
  end

  @impl true
  def handle_info(:run, opts) do
    # To doist.time_to_send_weekly_summary?(opts) -> send_completed_tasks(:last_week, opts)
    if Todoist.time_to_send_daily_summary?(opts) do
      send_completed_tasks(:last_24, opts)
    else
      loop(@fifteen_minutes)
    end

    {:noreply, opts}
  end

  defp loop(delay) do
    delay =
      case Application.get_env(:doit, :env) do
        :test -> 50
        _ -> delay
      end

    Process.send_after(__MODULE__, :run, delay, [])
  end

  defp send_completed_tasks(period, opts) do
    case Todoist.send_completed_tasks(period, opts) do
      :ok ->
        loop(@one_minute)

      error ->
        Logger.error("Cannot send completed task. Period: #{period}, error: #{inspect(error)}")
        loop(@five_minutes)
    end
  end
end
