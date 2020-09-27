defmodule Doit.GitHub.HTTPClient do
  alias Doit.GitHub

  @behaviour Doit.GitHub.Client
  @notifications_url "https://api.github.com/notifications"

  def notifications do
    headers = [
      Authorization: "Bearer #{github_token()}",
      Accept: "application/vnd.github.v3+json"
    ]

    now = DateTime.utc_now() |> DateTime.to_iso8601()

    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 5000, params: [before: now]]

    case HTTPoison.get(@notifications_url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        %GitHub.Response{notifications: Jason.decode!(body), headers: headers, timestamp: now}

      _ ->
        {:error, :bad_response}
    end
  end

  defp github_token do
    Application.fetch_env!(:doit, :github_token)
  end
end
