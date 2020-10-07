defmodule Doit.TodoistTest do
  use ExUnit.Case

  alias Doit.Todoist

  describe "get_completed_tasks/1" do
    test "can get completed tasks for the last 24 hours" do
      assert {:ok, tasks} = Todoist.get_completed_tasks(:last_24)

      assert %{
               "Exchanger" => [
                 %{
                   completed_at: ~U[2020-10-07 02:59:32Z],
                   content: "Use middleware for change set errors"
                 },
                 %{
                   completed_at: ~U[2020-10-07 02:15:37Z],
                   content: "resolve subscription order issue"
                 },
                 %{
                   completed_at: ~U[2020-10-07 02:02:24Z],
                   content: "Resolve N +1 wallet fetching with `aggregate_balances/3`"
                 }
               ],
               "doit" => [
                 %{
                   completed_at: ~U[2020-10-07 13:14:30Z],
                   content:
                     "clearly state that your application is “not created by, affiliated with, or supported by Doist” in your application description."
                 }
               ],
               "⌨️  Code" => [
                 %{
                   completed_at: ~U[2020-10-07 13:02:29Z],
                   content:
                     "Do daily review [[link]](https://todoist.com/API/v8.7/import/totally_not_a_fake_link.csv)"
                 }
               ],
               "🧍Relationships" => [
                 %{completed_at: ~U[2020-10-07 13:11:12Z], content: "Schedule talk with mom"}
               ]
             } = tasks
    end
  end
end
