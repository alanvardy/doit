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

  # Temporary for printing to terminal
  @spec pretty_print(map) :: {:ok, map}
  def pretty_print(task_list) do
    IO.puts("========= LAST 24 HOURS =========")

    for {project, tasks} <- task_list do
      IO.puts("\n== #{project} ==")

      for %{content: content, completed_at: completed_at} <- tasks do
        IO.puts(" - #{completed_at} - #{content}")
      end
    end

    {:ok, task_list}
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
