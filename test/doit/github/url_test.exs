defmodule Doit.GitHub.UrlTest do
  use ExUnit.Case
  alias Doit.GitHub.Url

  describe "format/1" do
    @issue_notification %{
      "subject" => %{
        "url" => "https://api.github.com/repos/someorg/some-repo/issues/14",
        "latest_comment_url" => nil
      }
    }
    test "returns an issue" do
      assert Url.format(@issue_notification) === %{
               repo: "some-repo",
               repo_url: "https://github.com/someorg/some-repo",
               url: "https://github.com/someorg/some-repo/issues/14"
             }
    end

    @pull_request_notification %{
      "subject" => %{
        "url" => "https://api.github.com/repos/someorg/some-repo/pulls/1773",
        "latest_comment_url" => nil
      }
    }
    test "returns a pull request" do
      assert Url.format(@pull_request_notification) === %{
               repo: "some-repo",
               repo_url: "https://github.com/someorg/some-repo",
               url: "https://github.com/someorg/some-repo/pull/1773"
             }
    end

    @pull_request_comment_notification %{
      "subject" => %{
        "url" => "https://api.github.com/repos/someorg/some-repo/pulls/1773",
        "latest_comment_url" =>
          "https://api.github.com/repos/someorg/some-repo/issues/comments/2345"
      }
    }

    test "returns a pull request comment" do
      assert Url.format(@pull_request_comment_notification) === %{
               repo: "some-repo",
               repo_url: "https://github.com/someorg/some-repo",
               url: "https://github.com/someorg/some-repo/issues/1773#issuecomment-2345"
             }
    end

    @repo_notification %{
      "subject" => %{
        "url" => "https://api.github.com/repos/someorg/some-repo",
        "latest_comment_url" => "https://api.github.com/repos/someorg/some-repo"
      }
    }
    test "returns a repo" do
      assert Url.format(@repo_notification) === %{
               repo: "some-repo",
               repo_url: "https://github.com/someorg/some-repo",
               url: "https://github.com/someorg/some-repo"
             }
    end
  end
end
