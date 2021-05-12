defmodule Doit.GitHub.Url do
  @moduledoc """
  GitHub doesnt just provide a link to an HTML page, we need to build it out of the API links.
  """

  @pull_request_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)\/pulls\/(?<pull_id>[\d]*)$/
  @comment_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)\/issues\/comments\/(?<comment_id>[\d]*)$/
  @repo_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)$/
  @issue_regex ~r/https:\/\/api.github.com\/repos\/(?<org>[^\/]*)\/(?<repo>[^\/]*)\/issues\/(?<issue_id>[\d]*)$/

  @spec format(map) :: %{repo: String.t(), url: String.t(), repo_url: String.t()}
  def format(notification) do
    comment_url = get_in(notification, ["subject", "latest_comment_url"])
    url = get_in(notification, ["subject", "url"])

    urls = %{comment_url: comment_url, url: url}

    cond do
      is_nil?(url) -> %{repo: "Unknown", url: comment_url, repo_url: comment_url}
      pull_request?(url, comment_url) -> format_url(urls, :pull_request)
      repo_notification?(url, comment_url) -> format_url(urls, :repo)
      pull_request_comment?(url, comment_url) -> format_url(urls, :pull_request)
      issue?(url, comment_url) -> format_url(urls, :issue)
      true -> %{repo: "Unknown", url: url, repo_url: url}
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

  defp pull_request_comment?(url, comment_url) do
    Regex.match?(@pull_request_regex, url) && Regex.match?(@comment_regex, comment_url)
  end

  defp issue?(url, _comment_url) do
    Regex.match?(@issue_regex, url)
  end

  defp format_url(%{url: url}, :pull_request) do
    %{"org" => org, "repo" => repo, "pull_id" => pull_id} =
      Regex.named_captures(@pull_request_regex, url)

    %{
      repo: repo,
      url: "https://github.com/#{org}/#{repo}/pull/#{pull_id}",
      repo_url: "https://github.com/#{org}/#{repo}"
    }
  end

  defp format_url(%{url: url, comment_url: comment_url}, :pull_request_comment) do
    %{"pull_id" => pull_id} = Regex.named_captures(@pull_request_regex, url)

    %{"org" => org, "repo" => repo, "comment_id" => comment_id} =
      Regex.named_captures(@comment_regex, comment_url)

    %{
      repo: repo,
      url: "https://github.com/#{org}/#{repo}/issues/#{pull_id}#issuecomment-#{comment_id}",
      repo_url: "https://github.com/#{org}/#{repo}"
    }
  end

  defp format_url(%{url: url}, :repo) do
    %{"org" => org, "repo" => repo} = Regex.named_captures(@repo_regex, url)

    %{
      repo: repo,
      url: "https://github.com/#{org}/#{repo}",
      repo_url: "https://github.com/#{org}/#{repo}"
    }
  end

  defp format_url(%{url: url}, :issue) do
    %{"org" => org, "repo" => repo, "issue_id" => issue_id} =
      Regex.named_captures(@issue_regex, url)

    %{
      repo: repo,
      url: "https://github.com/#{org}/#{repo}/issues/#{issue_id}",
      repo_url: "https://github.com/#{org}/#{repo}"
    }
  end
end
