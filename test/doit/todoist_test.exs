defmodule Doit.TodoistTest do
  use Doit.DataCase, async: true

  alias Doit.{Repo, Todoist}
  alias Doit.Todoist.Client.BadResponse
  alias Doit.Todoist.Notification

  describe "get_completed_tasks/1" do
    test "can get completed tasks for the last 24 hours" do
      assert :ok = Todoist.send_completed_tasks(:last_24)
      assert [%Notification{type: :last_24, data: data}] = Repo.all(Notification)

      assert %{
               "note" => """
               ========= LAST 24 HOURS =========

               == Exchanger ==
                - 2020-10-06 - Tue - 19:02 - Resolve N +1 wallet fetching with `aggregate_balances/3`
                - 2020-10-06 - Tue - 19:15 - resolve subscription order issue
                - 2020-10-06 - Tue - 19:59 - Use middleware for change set errors

               == doit ==
                - 2020-10-07 - Wed - 06:14 - clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description.

               == ⌨️  Code ==
                - 2020-10-07 - Wed - 06:02 - Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)

               == 🧍Relationships ==
                - 2020-10-07 - Wed - 06:11 - Schedule talk with mom\
               """,
               "task" => "Last 24 Hours"
             } = data
    end

    test "can get completed tasks for the last week" do
      assert :ok = Todoist.send_completed_tasks(:last_week)
      assert [%Notification{type: :last_week, data: data}] = Repo.all(Notification)

      assert %{
               "note" => """
               ========= LAST WEEK =========

               == Exchanger ==
                - 2020-10-06 - Tue - 19:02 - Resolve N +1 wallet fetching with `aggregate_balances/3`
                - 2020-10-06 - Tue - 19:15 - resolve subscription order issue
                - 2020-10-06 - Tue - 19:59 - Use middleware for change set errors

               == doit ==
                - 2020-10-07 - Wed - 06:14 - clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description.

               == ⌨️  Code ==
                - 2020-10-07 - Wed - 06:02 - Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)

               == 🧍Relationships ==
                - 2020-10-07 - Wed - 06:11 - Schedule talk with mom\
               """,
               "task" => "Last Week"
             } = data
    end

    test "can handle an erronous response" do
      assert {:error, :bad_response} = Todoist.send_completed_tasks(:last_24, client: BadResponse)
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
