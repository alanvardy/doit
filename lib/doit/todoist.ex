defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.Todoist.Client

  @spec create_tasks([String.t()]) :: :ok | {:error, :bad_response}
  def create_tasks(tasks) when is_list(tasks) do
    tasks
    |> Enum.map(&task_to_command/1)
    |> Client.create_tasks()
  end

  defp task_to_command(task) do
    %{
      "type" => "item_add",
      "temp_id" => new_uuid(),
      "uuid" => new_uuid(),
      "args" => %{"content" => task, "project_id" => project_id()}
    }
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end
end
