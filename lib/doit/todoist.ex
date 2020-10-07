defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.Todoist.{Client, CompletedTasks}

  @twenty_four_hours_ago -60 * 60 * 24

  @spec create_task(String.t()) :: :ok | {:error, :bad_response}
  def create_task(task) do
    task
    |> task_to_command()
    |> Client.create_task()
  end

  @spec get_completed_tasks(:last_24) :: {:ok, map} | {:error, String.t()}
  def get_completed_tasks(:last_24) do
    timestamp =
      DateTime.utc_now() |> DateTime.add(@twenty_four_hours_ago) |> datetime_to_timestamp()

    with {:ok, response} <- Client.completed_items(timestamp),
         {:ok, tasks} <- CompletedTasks.process(response) do
      {:ok, tasks}
    end
  end

  defp task_to_command(task) do
    %{
      "type" => "item_add",
      "temp_id" => new_uuid(),
      "uuid" => new_uuid(),
      "args" => %{"content" => task, "project_id" => project_id()}
    }
  end

  @spec datetime_to_timestamp(DateTime.t()) :: String.t()
  def datetime_to_timestamp(datetime) do
    %{year: year, month: month, day: day, hour: hour, minute: minute} = datetime

    "#{year}-#{month}-#{day}T#{hour}:#{minute}"
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end
end
