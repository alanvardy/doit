defmodule Doit.Todoist.MockServer do
  @moduledoc """
  Somewhere to send state in order to verify that Todoist would have had data sent to it.
  """
  use Agent

  @spec start_link(any) :: {:ok, pid()} | {:error, {:already_started, pid()} | term()}
  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @spec state :: [map]
  def state do
    Agent.get(__MODULE__, & &1)
  end

  @spec put(map) :: :ok
  def put(value) do
    Agent.update(__MODULE__, &[value | &1])
  end

  @spec clear :: :ok
  def clear do
    Agent.update(__MODULE__, fn _ -> [] end)
  end
end
