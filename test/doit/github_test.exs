defmodule Doit.GitHubTest do
  use ExUnit.Case
  alias Doit.GitHub

  describe "get_notifications/0" do
    test "gets notifications" do
      assert {:ok,
              %Doit.GitHub.Response{
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
                  {"Referrer-Policy",
                   "origin-when-cross-origin, strict-origin-when-cross-origin"},
                  {"Content-Security-Policy", "default-src 'none'"},
                  {"Vary", "Accept-Encoding, Accept, X-Requested-With"},
                  {"X-GitHub-Request-Id", "DD5F:2305:FB0D13:1928E0E:5F6FF708"}
                ],
                notifications: [
                  %{
                    title: "move match in pro build controller to its own controller",
                    type: "Pull Request",
                    url: "https://github.com/theblitzapp/blitz-backend/pull/1773"
                  },
                  %{
                    title: "rename scraper and aggregator in cluster defs",
                    type: "Pull Request",
                    url: "https://github.com/theblitzapp/blitz-backend/pull/1775"
                  }
                ],
                poll_interval: 60_000,
                timestamp: "2020-09-27T02:20:55.752557Z"
              }} = GitHub.get_notifications()
    end
  end
end
