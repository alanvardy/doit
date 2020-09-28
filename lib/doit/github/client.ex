defmodule Doit.GitHub.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a mocked Local client
  """
  @callback notifications :: {:ok, map} | {:error, :bad_response}
  @callback clear_notifications(String.t()) :: :ok | {:error, :bad_response}
  @client Application.fetch_env!(:doit, :github_client)

  defdelegate notifications, to: @client
  defdelegate clear_notifications(timestamp), to: @client
end
