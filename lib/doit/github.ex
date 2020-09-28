defmodule Doit.GitHub do
  @moduledoc """
  All things pertaining to calling the GitHub API and interpreting its output
  """
  alias Doit.GitHub.{Client, Notification, Response, Url}

  @spec get_notifications :: {:ok, Doit.GitHub.Response.t()} | {:error, :bad_response}
  def get_notifications do
    with {:ok, response} <- Client.notifications() do
      {:ok, format_response(response)}
    end
  end

  @spec tasks_from_response(Response.t()) :: [String.t()]
  def tasks_from_response(%Response{notifications: notifications}) do
    Enum.map(notifications, &task_from_notification/1)
  end

  @spec task_from_notification(Notification.t()) :: String.t()
  def task_from_notification(%Notification{} = notification) do
    %Notification{
      title: title,
      type: type,
      url: url,
      repo: repo,
      repo_url: repo_url
    } = notification

    "[#{repo}](#{repo_url}) -- #{type} -- [#{title}](#{url})"
  end

  defp format_response(response) do
    {"X-Poll-Interval", interval} =
      Enum.find(response.headers, {"X-Poll-Interval", "60"}, &(elem(&1, 0) == "X-Poll-Interval"))

    poll_interval =
      interval
      |> String.to_integer()
      |> :timer.seconds()

    %Response{
      timestamp: response.timestamp,
      headers: response.headers,
      poll_interval: poll_interval,
      notifications: Enum.map(response.notifications, &build_notification/1)
    }
  end

  defp build_notification(notification) do
    %{repo: repo, url: url, repo_url: repo_url} = Url.format(notification)

    %Notification{
      title: get_in(notification, ["subject", "title"]),
      type: format_type(notification),
      url: url,
      repo: repo,
      repo_url: repo_url
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
