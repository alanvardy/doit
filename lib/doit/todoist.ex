defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.Todoist.{Client, CompletedTasks}

  @type period :: :last_24 | :last_week

  @twenty_four_hours_ago -60 * 60 * 24
  @one_week_ago @twenty_four_hours_ago * 7
  @periods [:last_24, :last_week]

  @default_opts [client: Application.fetch_env!(:doit, :todoist_client)]

  @spec create_task(String.t()) :: :ok | {:error, :bad_response}
  @spec create_task(String.t(), keyword) :: :ok | {:error, :bad_response}
  def create_task(task, opts \\ @default_opts) when is_bitstring(task) do
    task
    |> task_to_command()
    |> Client.create_task(opts)
  end

  @spec get_completed_tasks(period) :: {:ok, map} | {:error, String.t()}
  @spec get_completed_tasks(period, keyword) :: {:ok, map} | {:error, String.t()}
  def get_completed_tasks(period, opts \\ @default_opts) when period in @periods do
    timestamp =
      period
      |> get_datetime()
      |> datetime_to_timestamp()

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

  @spec get_datetime(:last_24 | :last_week) :: DateTime.t()
  def get_datetime(:last_24), do: DateTime.add(DateTime.utc_now(), @twenty_four_hours_ago)
  def get_datetime(:last_week), do: DateTime.add(DateTime.utc_now(), @one_week_ago)

  @spec datetime_to_timestamp(DateTime.t()) :: String.t()
  def datetime_to_timestamp(datetime) do
    %{year: year, month: month, day: day, hour: hour, minute: minute} = datetime

    "#{year}-#{zero_pad(month)}-#{zero_pad(day)}T#{zero_pad(hour)}:#{zero_pad(minute)}"
  end

  @spec zero_pad(pos_integer) :: String.t()
  def zero_pad(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end
end
