defmodule Doit.GitHub do
  @moduledoc """
  All things pertaining to calling the GitHub API and interpreting its output
  """
  alias Doit.GitHub.{Client, Response, Url}

  @spec get_notifications :: {:ok, Doit.GitHub.Response.t()} | {:error, :bad_response}
  def get_notifications do
    with {:ok, response} <- Client.notifications() do
      {:ok, format_response(response)}
    end
  end

  defp format_response(%Response{} = response) do
    {"X-Poll-Interval", interval} =
      Enum.find(response.headers, {"X-Poll-Interval", "60"}, &(elem(&1, 0) == "X-Poll-Interval"))

    poll_interval =
      interval
      |> String.to_integer()
      |> :timer.seconds()

    %Response{
      response
      | poll_interval: poll_interval,
        notifications: Enum.map(response.notifications, &build_notification/1)
    }
  end

  defp build_notification(notification) do
    %{
      title: get_in(notification, ["subject", "title"]),
      type: format_type(notification),
      url: Url.format(notification)
    }
  end

  defp format_type(notification) do
    case get_in(notification, ["subject", "type"]) do
      "PullRequest" -> "Pull Request"
      "RepositoryVulnerabilityAlert" -> "Alert"
      other -> other
    end
  end
end
