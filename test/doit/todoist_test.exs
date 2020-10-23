defmodule Doit.TodoistTest do
  use Doit.DataCase, async: true

  alias Doit.Todoist
  alias Doit.Todoist.Client.BadResponse

  describe "get_completed_tasks/1" do
    test "can get completed tasks for the last 24 hours" do
      assert {:ok,
              [
                %{
                  "args" => %{
                    "auto_parse_labels" => true,
                    "content" => "Last 24 Hours @computer",
                    "priority" => 2,
                    "project_id" => "123456789"
                  },
                  "temp_id" => item_id,
                  "type" => "item_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== Exchanger ==\n - 2020-10-06 - Tue - 19:02 - Resolve N +1 wallet fetching with `aggregate_balances/3`\n - 2020-10-06 - Tue - 19:15 - resolve subscription order issue\n - 2020-10-06 - Tue - 19:59 - Use middleware for change set errors",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== doit ==\n - 2020-10-07 - Wed - 06:14 - clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description.",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== ⌨️  Code ==\n - 2020-10-07 - Wed - 06:02 - Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== 🧍Relationships ==\n - 2020-10-07 - Wed - 06:11 - Schedule talk with mom",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                }
              ]} = Todoist.get_completed_tasks(:last_24)
    end

    test "can get completed tasks for the last week" do
      assert {:ok,
              [
                %{
                  "args" => %{
                    "auto_parse_labels" => true,
                    "content" => "Last Week @computer",
                    "priority" => 2,
                    "project_id" => "123456789"
                  },
                  "temp_id" => item_id,
                  "type" => "item_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== Exchanger ==\n - 2020-10-06 - Tue - 19:02 - Resolve N +1 wallet fetching with `aggregate_balances/3`\n - 2020-10-06 - Tue - 19:15 - resolve subscription order issue\n - 2020-10-06 - Tue - 19:59 - Use middleware for change set errors",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== doit ==\n - 2020-10-07 - Wed - 06:14 - clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description.",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== ⌨️  Code ==\n - 2020-10-07 - Wed - 06:02 - Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                },
                %{
                  "args" => %{
                    "content" =>
                      "== 🧍Relationships ==\n - 2020-10-07 - Wed - 06:11 - Schedule talk with mom",
                    "item_id" => item_id
                  },
                  "temp_id" => _,
                  "type" => "note_add",
                  "uuid" => _
                }
              ]} = Todoist.get_completed_tasks(:last_week)
    end

    test "can handle an erronous response" do
      assert {:error, :bad_response} = Todoist.get_completed_tasks(:last_24, client: BadResponse)
    end
  end

  describe "create_task/1" do
    test "can create a task" do
      assert :ok = Todoist.create_task(%{task: "something"})
    end

    test "can handle an erronous response" do
      assert {:error, :bad_response} =
               Todoist.create_task(%{task: "something"}, client: BadResponse)
    end
  end
end
