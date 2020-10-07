defmodule Doit.Todoist.CompletedTasks do
  @moduledoc """
  Handles processing the completed tasks response
  """
  @spec process(map) :: {:ok, any} | {:error, String.t()}
  def process(%{"items" => tasks, "projects" => projects}) do
    result =
      tasks
      |> Enum.map(&process_task/1)
      |> Enum.group_by(& &1.project_id, &Map.take(&1, [:content, :completed_at]))
      |> Enum.into(%{}, fn {k, v} -> {get_project_name(k, projects), v} end)

    {:ok, result}
  end

  def process(response) do
    {:error, "malformed response: #{inspect(response)}"}
  end

  defp process_task(task) do
    %{
      completed_at: task["completed_date"] |> timestamp_to_datetime(),
      content: task["content"],
      project_id: task["project_id"]
    }
  end

  defp timestamp_to_datetime(timestamp) do
    {:ok, datetime, 0} = DateTime.from_iso8601(timestamp)
    datetime
  end

  defp get_project_name(key, projects) do
    get_in(projects, [to_string(key), "name"])
  end
end
