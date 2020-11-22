defmodule Doit.Todoist.CompletedTasksTest do
  use Doit.DataCase, async: true
  alias Doit.Todoist.CompletedTasks

  describe "process/1" do
    test "rejects invalid parameters" do
      for item <- [nil, %{}, %{something: "else"}] do
        assert {:error, "malformed response: " <> _} = CompletedTasks.process(item)
      end
    end
  end
end
