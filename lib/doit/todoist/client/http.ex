defmodule Doit.Todoist.Client.HTTP do
  @moduledoc """
  The actual client for GitHub
  """
  alias HTTPoison.Response
  require Logger

  @behaviour Doit.Todoist.Client
  @create_task_url "https://api.todoist.com/sync/v8/sync"
  @completed_item_url "https://api.todoist.com/sync/v8/completed/get_all"

  @impl true
  @spec create_task(map) :: :ok | {:error, :bad_response}
  def create_task(commands) do
    headers = [Accept: "Application/json; Charset=utf-8"]

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: 5000,
      params: [token: todoist_token(), commands: Jason.encode!([commands])]
    ]

    case HTTPoison.post(@create_task_url, "", headers, options) do
      {:ok, %Response{status_code: 200}} -> :ok
      error ->
       log_error("create_task/1", [commands], error)
        {:error, :bad_response}
    end
  end

  @impl true
  @spec completed_items(String.t()) :: {:ok, map} | {:error, :bad_response}
  def completed_items(timestamp) do
    headers = [Accept: "Application/json; Charset=utf-8"]

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: 5000,
      params: [token: todoist_token(), since: timestamp, limit: 200]
    ]

    case HTTPoison.post(@completed_item_url, "", headers, options) do
      {:ok, %Response{status_code: 200, body: body}} -> {:ok, Jason.decode!(body)}
      error ->
        log_error("completed_items/1", [timestamp], error)
        {:error, :bad_response}
    end
  end

  defp todoist_token do
    Application.fetch_env!(:doit, :todoist_token)
  end

  defp log_error(function, arguments, error) do
    Logger.error """
    Error in module: #{inspect __MODULE__}
    Function: #{inspect function}
    Arguments: #{inspect arguments}
    Error: #{inspect error}
    """
  end
end
