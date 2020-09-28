defmodule Doit.GitHub.Client.Local do
  @moduledoc """
  Mock client for GitHub
  """
  @behaviour Doit.GitHub.Client

  @impl true
  def notifications do
    {:ok,
     %{
       notifications: [
         %{
           "id" => "1192830250",
           "last_read_at" => nil,
           "reason" => "comment",
           "repository" => %{
             "statuses_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/statuses/{sha}",
             "git_refs_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/refs{/sha}",
             "issue_comment_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues/comments{/number}",
             "languages_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/languages",
             "comments_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/comments{/number}",
             "commits_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/commits{/sha}",
             "id" => 74_417_982,
             "stargazers_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/stargazers",
             "events_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/events",
             "blobs_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/blobs{/sha}",
             "hooks_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/hooks",
             "owner" => %{
               "avatar_url" => "https://avatars3.githubusercontent.com/u/4267635?v=4",
               "events_url" => "https://api.github.com/users/theblitzapp/events{/privacy}",
               "followers_url" => "https://api.github.com/users/theblitzapp/followers",
               "following_url" =>
                 "https://api.github.com/users/theblitzapp/following{/other_user}",
               "gists_url" => "https://api.github.com/users/theblitzapp/gists{/gist_id}",
               "gravatar_id" => "",
               "html_url" => "https://github.com/theblitzapp",
               "id" => 4_267_635,
               "login" => "theblitzapp",
               "node_id" => "MDEyOk9yZ2FuaXphdGlvbjQyNjc2MzU=",
               "organizations_url" => "https://api.github.com/users/theblitzapp/orgs",
               "received_events_url" =>
                 "https://api.github.com/users/theblitzapp/received_events",
               "repos_url" => "https://api.github.com/users/theblitzapp/repos",
               "site_admin" => false,
               "starred_url" => "https://api.github.com/users/theblitzapp/starred{/owner}{/repo}",
               "subscriptions_url" => "https://api.github.com/users/theblitzapp/subscriptions",
               "type" => "Organization",
               "url" => "https://api.github.com/users/theblitzapp"
             },
             "trees_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/trees{/sha}",
             "git_commits_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/commits{/sha}",
             "collaborators_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/collaborators{/collaborator}",
             "tags_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/tags",
             "merges_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/merges",
             "releases_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/releases{/id}",
             "subscribers_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/subscribers",
             "name" => "blitz-backend",
             "private" => true,
             "git_tags_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/tags{/sha}",
             "archive_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/{archive_format}{/ref}",
             "milestones_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/milestones{/number}",
             "forks_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/forks",
             "url" => "https://api.github.com/repos/theblitzapp/blitz-backend",
             "downloads_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/downloads",
             "keys_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/keys{/key_id}",
             "description" => "Blitz Backend",
             "contents_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/contents/{+path}",
             "contributors_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/contributors",
             "deployments_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/deployments",
             "pulls_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/pulls{/number}",
             "labels_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/labels{/name}",
             "html_url" => "https://github.com/theblitzapp/blitz-backend",
             "issue_events_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues/events{/number}",
             "notifications_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/notifications{?since,all,participating}",
             "node_id" => "MDEwOlJlcG9zaXRvcnk3NDQxNzk4Mg==",
             "compare_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/compare/{base}...{head}",
             "full_name" => "theblitzapp/blitz-backend",
             "subscription_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/subscription",
             "assignees_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/assignees{/user}",
             "issues_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues{/number}",
             "fork" => false,
             "branches_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/branches{/branch}"
           },
           "subject" => %{
             "latest_comment_url" => nil,
             "title" => "move match in pro build controller to its own controller",
             "type" => "PullRequest",
             "url" => "https://api.github.com/repos/theblitzapp/blitz-backend/pulls/1773"
           },
           "subscription_url" =>
             "https://api.github.com/notifications/threads/1192830250/subscription",
           "unread" => true,
           "updated_at" => "2020-09-25T20:41:32Z",
           "url" => "https://api.github.com/notifications/threads/1192830250"
         },
         %{
           "id" => "1194780028",
           "last_read_at" => "2020-09-25T16:59:52Z",
           "reason" => "comment",
           "repository" => %{
             "statuses_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/statuses/{sha}",
             "git_refs_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/refs{/sha}",
             "issue_comment_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues/comments{/number}",
             "languages_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/languages",
             "comments_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/comments{/number}",
             "commits_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/commits{/sha}",
             "id" => 74_417_982,
             "stargazers_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/stargazers",
             "events_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/events",
             "blobs_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/blobs{/sha}",
             "hooks_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/hooks",
             "owner" => %{
               "avatar_url" => "https://avatars3.githubusercontent.com/u/4267635?v=4",
               "events_url" => "https://api.github.com/users/theblitzapp/events{/privacy}",
               "followers_url" => "https://api.github.com/users/theblitzapp/followers",
               "following_url" =>
                 "https://api.github.com/users/theblitzapp/following{/other_user}",
               "gists_url" => "https://api.github.com/users/theblitzapp/gists{/gist_id}",
               "gravatar_id" => "",
               "html_url" => "https://github.com/theblitzapp",
               "id" => 4_267_635,
               "login" => "theblitzapp",
               "node_id" => "MDEyOk9yZ2FuaXphdGlvbjQyNjc2MzU=",
               "organizations_url" => "https://api.github.com/users/theblitzapp/orgs",
               "received_events_url" =>
                 "https://api.github.com/users/theblitzapp/received_events",
               "repos_url" => "https://api.github.com/users/theblitzapp/repos",
               "site_admin" => false,
               "starred_url" => "https://api.github.com/users/theblitzapp/starred{/owner}{/repo}",
               "subscriptions_url" => "https://api.github.com/users/theblitzapp/subscriptions",
               "type" => "Organization",
               "url" => "https://api.github.com/users/theblitzapp"
             },
             "trees_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/trees{/sha}",
             "git_commits_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/commits{/sha}",
             "collaborators_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/collaborators{/collaborator}",
             "tags_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/tags",
             "merges_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/merges",
             "releases_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/releases{/id}",
             "subscribers_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/subscribers",
             "name" => "blitz-backend",
             "private" => true,
             "git_tags_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/git/tags{/sha}",
             "archive_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/{archive_format}{/ref}",
             "milestones_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/milestones{/number}",
             "forks_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/forks",
             "url" => "https://api.github.com/repos/theblitzapp/blitz-backend",
             "downloads_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/downloads",
             "keys_url" => "https://api.github.com/repos/theblitzapp/blitz-backend/keys{/key_id}",
             "description" => "Blitz Backend",
             "contents_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/contents/{+path}",
             "contributors_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/contributors",
             "deployments_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/deployments",
             "pulls_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/pulls{/number}",
             "labels_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/labels{/name}",
             "html_url" => "https://github.com/theblitzapp/blitz-backend",
             "issue_events_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues/events{/number}",
             "notifications_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/notifications{?since,all,participating}",
             "node_id" => "MDEwOlJlcG9zaXRvcnk3NDQxNzk4Mg==",
             "compare_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/compare/{base}...{head}",
             "full_name" => "theblitzapp/blitz-backend",
             "subscription_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/subscription",
             "assignees_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/assignees{/user}",
             "issues_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/issues{/number}",
             "fork" => false
           },
           "subject" => %{
             "latest_comment_url" =>
               "https://api.github.com/repos/theblitzapp/blitz-backend/pulls/1775",
             "title" => "rename scraper and aggregator in cluster defs",
             "type" => "PullRequest",
             "url" => "https://api.github.com/repos/theblitzapp/blitz-backend/pulls/1775"
           },
           "subscription_url" =>
             "https://api.github.com/notifications/threads/1194780028/subscription",
           "unread" => true,
           "updated_at" => "2020-09-25T18:21:39Z",
           "url" => "https://api.github.com/notifications/threads/1194780028"
         }
       ],
       headers: [
         {"Server", "GitHub.com"},
         {"Date", "Sun, 27 Sep 2020 02:20:56 GMT"},
         {"Content-Type", "application/json; charset=utf-8"},
         {"Content-Length", "186193"},
         {"Status", "200 OK"},
         {"Cache-Control", "private, max-age=60, s-maxage=60"},
         {"Vary", "Accept, Authorization, Cookie, X-GitHub-OTP"},
         {"ETag", "\"\""},
         {"Last-Modified", "Fri, 25 Sep 2020 20:41:32 GMT"},
         {"X-Poll-Interval", "60"},
         {"X-OAuth-Scopes", "admin:org, repo, user"},
         {"X-Accepted-OAuth-Scopes", "notifications, repo"},
         {"X-GitHub-Media-Type", "github.v3; format=json"},
         {"X-RateLimit-Limit", "5000"},
         {"X-RateLimit-Remaining", "4999"},
         {"X-RateLimit-Reset", "1601176856"},
         {"X-RateLimit-Used", "1"},
         {"Access-Control-Expose-Headers",
          "ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, Deprecation, Sunset"},
         {"Access-Control-Allow-Origin", "*"},
         {"Strict-Transport-Security", "max-age=31536000; includeSubdomains; preload"},
         {"X-Frame-Options", "deny"},
         {"X-Content-Type-Options", "nosniff"},
         {"X-XSS-Protection", "1; mode=block"},
         {"Referrer-Policy", "origin-when-cross-origin, strict-origin-when-cross-origin"},
         {"Content-Security-Policy", "default-src 'none'"},
         {"Vary", "Accept-Encoding, Accept, X-Requested-With"},
         {"X-GitHub-Request-Id", "DD5F:2305:FB0D13:1928E0E:5F6FF708"}
       ],
       timestamp: "2020-09-27T02:20:55.752557Z"
     }}
  end

  @impl true
  def clear_notifications(_timestamp), do: :ok
end
