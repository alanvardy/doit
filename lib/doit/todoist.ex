defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.Time
  alias Doit.Todoist.{Client, CompletedTasks}

  @type period :: :last_24 | :last_week

  @periods [:last_24, :last_week]

  @default_opts [client: Application.fetch_env!(:doit, :todoist_client)]

  @spec create_task(String.t()) :: :ok | {:error, :bad_response}
  @spec create_task(String.t(), keyword) :: :ok | {:error, :bad_response}
  def create_task(task, opts \\ []) when is_bitstring(task) do
    opts = Keyword.merge(@default_opts, opts)

    task
    |> task_to_command()
    |> Client.create_task(opts)
  end

  @spec get_completed_tasks(period) :: {:ok, map} | {:error, String.t()}
  @spec get_completed_tasks(period, keyword) :: {:ok, map} | {:error, String.t()}
  def get_completed_tasks(period, opts \\ []) when period in @periods do
    opts = Keyword.merge(@default_opts, opts)

    timestamp =
      period
      |> Time.get_datetime()
      |> Time.datetime_to_timestamp()

    with {:ok, response} <- Client.completed_items(timestamp, opts),
         {:ok, tasks} <- CompletedTasks.process(response) do
      CompletedTasks.pretty_print(tasks, period)
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

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end
end
