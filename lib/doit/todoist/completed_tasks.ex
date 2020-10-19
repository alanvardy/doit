defmodule Doit.Todoist.CompletedTasks do
  @moduledoc """
  Handles processing the completed tasks response
  """

  alias Doit.Time

  @type period :: :last_24 | :last_week
  @spec process(map) :: {:ok, any} | {:error, String.t()}
  def process(%{items: items, projects: projects}) do
    result =
      items
      |> Enum.map(&process_task/1)
      |> Enum.sort(&(&1.completed_at <= &2.completed_at))
      |> Enum.group_by(& &1.project_id, &Map.take(&1, [:content, :completed_at]))
      |> Enum.into(%{}, fn {k, v} -> {get_project_name(k, projects), v} end)

    {:ok, result}
  end

  def process(response) do
    {:error, "malformed response: #{inspect(response)}"}
  end

  @spec pretty_print(map, :last_24 | :last_week) :: [String.t()]
  def pretty_print(task_list, period) do
    text =
      case period do
        :last_24 -> "LAST 24 HOURS"
        :last_week -> "LAST WEEK"
      end

    [
      "========= #{text} =========",
      for {project, tasks} <- task_list do
        [
          "== #{project} ==",
          for %{content: content, completed_at: completed_at} <- tasks do
            " - #{Time.humanize(completed_at)} - #{content}"
          end
        ]
        |> List.flatten()
        |> Enum.join("\n")
      end
    ]
    |> List.flatten()
  end

  defp process_task(task) do
    %{
      completed_at: task["completed_date"] |> Time.timestamp_to_datetime(),
      content: task["content"],
      project_id: task["project_id"]
    }
  end

  defp get_project_name(key, projects) do
    get_in(projects, [to_string(key), "name"])
  end
end
