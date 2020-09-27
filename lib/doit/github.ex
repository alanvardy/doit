defmodule Doit.GitHub do
  @moduledoc """
  All things pertaining to calling the GitHub API and interpreting its output
  """
  alias Doit.GitHub.{Client, Response}

  @pull_request_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)\/pulls\/(?<pull_id>[\d]*)$/
  @comment_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)\/issues\/comments\/(?<comment_id>[\d]*)$/
  @repo_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)$/

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
      url: format_url(notification)
    }
  end

  defp format_url(notification) do
    comment_url = get_in(notification, ["subject", "latest_comment_url"])
    url = get_in(notification, ["subject", "url"])

    urls = %{comment_url: comment_url, url: url}

    cond do
      pull_request?(url, comment_url) -> format_url(urls, :pull_request)
      repo_notification?(url, comment_url) -> format_url(urls, :repo)
      pull_reqest_comment?(url, comment_url) -> format_url(urls, :pull_request_comment)
      true -> url
    end
  end

  defp pull_request?(url, nil) do
    Regex.match?(@pull_request_regex, url)
  end

  defp pull_request?(urls_match, urls_match) do
    Regex.match?(@pull_request_regex, urls_match)
  end

  defp pull_request?(_, _), do: false

  defp repo_notification?(url, nil) do
    Regex.match?(@repo_regex, url)
  end

  defp repo_notification?(urls_match, urls_match) do
    Regex.match?(@repo_regex, urls_match)
  end

  defp repo_notification?(_, _), do: false

  defp pull_reqest_comment?(url, comment_url) do
    Regex.match?(@pull_request_regex, url) && Regex.match?(@comment_regex, comment_url)
  end

  defp format_url(%{url: url}, :pull_request) do
    %{"org" => org, "repo" => repo, "pull_id" => pull_id} =
      Regex.named_captures(@pull_request_regex, url)

    "https://github.com/#{org}/#{repo}/pull/#{pull_id}"
  end

  defp format_url(%{url: url, comment_url: comment_url}, :pull_request_comment) do
    %{"pull_id" => pull_id} = Regex.named_captures(@pull_request_regex, url)

    %{"org" => org, "repo" => repo, "comment_id" => comment_id} =
      Regex.named_captures(@comment_regex, comment_url)

    "https://github.com/#{org}/#{repo}/issues/#{pull_id}#issuecomment-#{comment_id}"
  end

  defp format_url(%{url: url}, :repo) do
    %{"org" => org, "repo" => repo} = Regex.named_captures(@repo_regex, url)

    "https://github.com/#{org}/#{repo}"
  end

  defp format_type(notification) do
    case get_in(notification, ["subject", "type"]) do
      "PullRequest" -> "Pull Request"
      "RepositoryVulnerabilityAlert" -> "Alert"
      other -> other
    end
  end
end
