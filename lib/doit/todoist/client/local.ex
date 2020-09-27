defmodule Doit.Todoist.Client.Local do
  @moduledoc """
  Mock client for Todoist
  """
  @behaviour Doit.Todoist.Client

  @spec create_tasks([String.t()]) :: :ok | {:error, :bad_response}
  def create_tasks(_tasks), do: :ok
end
