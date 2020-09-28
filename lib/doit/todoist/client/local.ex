defmodule Doit.Todoist.Client.Local do
  @moduledoc """
  Mock client for Todoist
  """
  @behaviour Doit.Todoist.Client

  @spec create_task(map) :: :ok | {:error, :bad_response}
  def create_task(_task), do: :ok
end
