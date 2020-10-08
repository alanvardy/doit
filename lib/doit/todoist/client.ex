defmodule Doit.Todoist.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a stubbed Local client
  """
  @callback create_task(map) :: :ok | {:error, :bad_response}
  @callback completed_items(String.t()) :: {:ok, map} | {:error, :bad_response}
  @default_opts [client: Application.fetch_env!(:doit, :github_client)]

  @spec create_task(map, keyword) :: :ok | {:error, :bad_response}
  def create_task(commands, opts \\ @default_opts) do
    opts[:client].create_task(commands)
  end

  @spec completed_items(String.t(), keyword) :: {:ok, map} | {:error, :bad_response}
  def completed_items(timestamp, opts \\ @default_opts) do
    opts[:client].completed_items(timestamp)
  end
end
