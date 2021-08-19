defmodule Doit.GitHub.Client.HTTP do
  @moduledoc """
  The actual client for GitHub
  """

  require Logger
  alias Tesla.{Client, Env}

  @behaviour Doit.GitHub.Client
  @base_url "https://api.github.com"
  @github_token Application.compile_env(:doit, :github_token)

  @spec client(String.t()) :: Client.t()
  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "token " <> token},
         {"accept", "application/vnd.github.v3+json"},
         {"user-agent", "Tesla"}
       ]}
    ]

    adapter = {Tesla.Adapter.Hackney, [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 5000]}
    Tesla.client(middleware, adapter)
  end

  @impl true
  def notifications do
    now = DateTime.utc_now() |> DateTime.to_iso8601()

    @github_token
    |> client()
    |> Tesla.get("/notifications", query: [before: now])
    |> case do
      {:ok, %Env{status: 200, body: body, headers: headers}} ->
        {:ok, %{notifications: body, headers: headers, timestamp: now}}

      error ->
        log_error("notifications/0", [], error)
        {:error, :bad_response}
    end
  end

  @impl true
  def pull_merge_status("https://github.com" <> url) do
    @github_token
    |> client()
    |> Tesla.get(url <> "/merge")
    |> case do
      {:ok, %Env{status: 204}} ->
        {:ok, :merged}

      {:ok, %Env{status: 404}} ->
        {:ok, :open}

      error ->
        log_error("merge_request/1", [], error)
        {:ok, :open}
    end
  end

  @impl true
  def clear_notifications(timestamp) do
    @github_token
    |> client()
    |> Tesla.put("/notifications", query: [last_read_at: timestamp])
    |> case do
      {:ok, %Env{status: 205}} ->
        :ok

      {:ok, %Env{status: 202}} ->
        :ok

      error ->
        log_error("clear_notifications/1", [timestamp], error)
        {:error, :bad_response}
    end
  end

  defp log_error(function, arguments, error) do
    Logger.error("""
    Error in module: #{inspect(__MODULE__)}
    Function: #{inspect(function)}
    Arguments: #{inspect(arguments)}
    Error: #{inspect(error)}
    """)
  end
end
