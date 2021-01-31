defmodule Doit.NotificationPipelineTest do
  use Doit.DataCase
  alias Doit.NotificationPipeline
  alias Doit.Todoist.MockServer

  setup do
    start_supervised!({MockServer, []})
    start_supervised!({NotificationPipeline, []})
    Process.sleep(50)
    :ok
  end

  describe "Notification pipeline" do
    test "creates tasks" do
      assert [
               %{
                 "args" => %{
                   "content" =>
                     "[some-repo](https://github.com/alanvardy/some-repo) -- Pull Request -- [rename scraper and aggregator in cluster defs](https://github.com/alanvardy/some-repo/pull/1775) @computer",
                   "priority" => 2,
                   "project_id" => "123456789"
                 },
                 "temp_id" => temp_id,
                 "type" => "item_add",
                 "uuid" => uuid
               },
               %{
                 "args" => %{
                   "content" =>
                     "[some-repo](https://github.com/alanvardy/some-repo) -- Pull Request -- [move match in pro build controller to its own controller](https://github.com/alanvardy/some-repo/pull/1773) @computer",
                   "priority" => 2,
                   "project_id" => "123456789"
                 },
                 "temp_id" => temp_id2,
                 "type" => "item_add",
                 "uuid" => uuid2
               }
             ] = MockServer.state()

      assert is_binary(temp_id)
      assert is_binary(uuid)
      assert is_binary(temp_id2)
      assert is_binary(uuid2)
    end
  end
end
