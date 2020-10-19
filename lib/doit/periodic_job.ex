defmodule Doit.PeriodicJob do
  @moduledoc "Runs periodic jobs that are not time sensitive"
  use GenServer
  require Logger

  alias Doit.Todoist

  @one_minute :timer.minutes(1)
  @five_minutes :timer.minutes(5)
  @fifteen_minutes :timer.minutes(15)

  # Client

  @spec start_link(any) :: {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    loop(50)
    {:ok, state}
  end

  @impl true
  def handle_info(:run, state) do
    cond do
      Todoist.time_to_send_weekly_summary?() ->
        :ok = Todoist.send_completed_tasks(:last_week)
        loop(@one_minute)

      Todoist.time_to_send_daily_summary?() ->
        :ok = Todoist.send_completed_tasks(:last_24)
        loop(@five_minutes)

      true ->
        loop(@fifteen_minutes)
    end

    {:noreply, state}
  end

  defp loop(delay) do
    Process.send_after(__MODULE__, :run, delay, [])
  end
end
