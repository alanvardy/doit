defmodule Doit.TodoistTest do
  use ExUnit.Case
  alias Doit.Todoist

  describe "create_tasks/1" do
    test "creates tasks" do
      assert :ok = Todoist.create_tasks(["something"])
    end
  end
end
