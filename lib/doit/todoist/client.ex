defmodule Doit.Todoist.Client do
  @moduledoc """
  Client abstraction that can call the HTTP client or a stubbed Local client
  """

  @type resp :: {:ok, %{items: [map], projects: map}} | {:error, :bad_response}

  @callback create_task(map) :: :ok | {:error, :bad_response}
  @callback completed_items(String.t()) :: resp
  @callback completed_items(String.t(), keyword) :: resp
  @default_opts [client: Application.compile_env(:doit, :github_client)]

  @spec create_task(map, keyword) :: :ok | {:error, :bad_response}
  def create_task(commands, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)
    opts[:client].create_task(commands)
  end

  @spec completed_items(String.t(), keyword) :: {:ok, map} | {:error, :bad_response}
  def completed_items(timestamp, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)
    opts[:client].completed_items(timestamp)
  end
end
