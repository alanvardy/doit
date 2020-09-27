defmodule Doit.GitHub.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a mocked Local client
  """
  alias Doit.GitHub.Response
  @callback notifications :: {:ok, Response.t()} | {:error, :bad_response}
  @client Application.fetch_env!(:doit, :github_client)

  defdelegate notifications, to: @client
end
