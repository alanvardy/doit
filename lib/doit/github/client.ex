defmodule Doit.GitHub.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a mocked Local client
  """
  @callback notifications :: {:ok, map} | {:error, :bad_response}
  @callback clear_notifications(String.t()) :: :ok | {:error, :bad_response}
  @default_opts [client: Application.compile_env(:doit, :github_client)]

  @spec notifications :: {:ok, map} | {:error, :bad_response}
  @spec notifications(keyword) :: {:ok, map} | {:error, :bad_response}
  def notifications(opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    opts[:client].notifications()
  end

  @spec clear_notifications(String.t()) :: :ok | {:error, :bad_response}
  @spec clear_notifications(String.t(), keyword) :: :ok | {:error, :bad_response}
  def clear_notifications(timestamp, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    opts[:client].clear_notifications(timestamp)
  end
end
