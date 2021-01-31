defmodule Doit.Todoist.MockServer do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  def put(value) do
    Agent.update(__MODULE__, &[value | &1])
  end

  def clear do
    Agent.update(__MODULE__, fn _ -> [] end)
  end
end
