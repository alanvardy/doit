defmodule Doit.GitHub.Client.HTTP do
  @moduledoc """
  The actual client for GitHub
  """

  alias HTTPoison.Response

  @behaviour Doit.GitHub.Client
  @notifications_url "https://api.github.com/notifications"

  @impl true
  def notifications do
    headers = [
      Authorization: "Bearer #{github_token()}",
      Accept: "application/vnd.github.v3+json"
    ]

    now = DateTime.utc_now() |> DateTime.to_iso8601()

    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 5000, params: [before: now]]

    case HTTPoison.get(@notifications_url, headers, options) do
      {:ok, %Response{status_code: 200, body: body, headers: headers}} ->
        {:ok, %{notifications: Jason.decode!(body), headers: headers, timestamp: now}}

      _ ->
        {:error, :bad_response}
    end
  end

  @impl true
  def clear_notifications(timestamp) do
    headers = [
      Authorization: "Bearer #{github_token()}",
      Accept: "application/vnd.github.v3+json"
    ]

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: 5000,
      params: [last_read_at: timestamp]
    ]

    case HTTPoison.put(@notifications_url, "", headers, options) do
      {:ok, %Response{status_code: 205}} -> :ok
      {:ok, %Response{status_code: 202}} -> :ok
      _ -> {:error, :bad_response}
    end
  end

  defp github_token do
    Application.fetch_env!(:doit, :github_token)
  end
end