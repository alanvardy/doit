defmodule Doit.Todoist.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a mocked Local client
  """
  @callback create_task(map) :: :ok | {:error, :bad_response}
  @client Application.fetch_env!(:doit, :todoist_client)

  defdelegate create_task(commands), to: @client
end
