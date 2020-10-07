defmodule Doit.Todoist.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a mocked Local client
  """
  @callback create_task(map) :: :ok | {:error, :bad_response}
  @callback completed_items(String.t()) :: {:ok, map} | {:error, :bad_response}
  @client Application.fetch_env!(:doit, :todoist_client)

  defdelegate create_task(commands), to: @client
  defdelegate completed_items(timestamp), to: @client
end
