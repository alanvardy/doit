defmodule Doit.GitHub.Client.HTTP do
  @moduledoc """
  The actual client for GitHub
  """

  require Logger
  alias HTTPoison.Response

  @behaviour Doit.GitHub.Client
  @notifications_url "https://api.github.com/notifications"
  @github_token Application.compile_env(:doit, :github_token)

  @impl true
  def notifications do
    headers = [
      Authorization: "Bearer #{@github_token}",
      Accept: "application/vnd.github.v3+json"
    ]

    now = DateTime.utc_now() |> DateTime.to_iso8601()

    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 5000, params: [before: now]]

    case HTTPoison.get(@notifications_url, headers, options) do
      {:ok, %Response{status_code: 200, body: body, headers: headers}} ->
        {:ok, %{notifications: Jason.decode!(body), headers: headers, timestamp: now}}

      error ->
        log_error("notifications/0", [], error)
        {:error, :bad_response}
    end
  end

  @impl true
  def pull_merge_status(url) do
    headers = [
      Authorization: "Bearer #{@github_token}",
      Accept: "application/vnd.github.v3+json"
    ]

    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 5000]

    case HTTPoison.get(url <> "/merge", headers, options) do
      {:ok, %Response{status_code: 204}} ->        {:ok, :merged}

      {:ok, %Response{status_code: 404}} ->        {:ok, :open}

      error ->
        log_error("merge_request/1", [], error)
        {:ok, :open}
    end
  end

  @impl true
  def clear_notifications(timestamp) do
    headers = [
      Authorization: "Bearer #{@github_token}",
      Accept: "application/vnd.github.v3+json"
    ]

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: 5000,
      params: [last_read_at: timestamp]
    ]

    case HTTPoison.put(@notifications_url, "", headers, options) do
      {:ok, %Response{status_code: 205}} ->
        :ok

      {:ok, %Response{status_code: 202}} ->
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
