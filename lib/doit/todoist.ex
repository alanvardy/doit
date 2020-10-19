defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.{Repo, Time}
  alias Doit.Todoist.{Client, CompletedTasks, Notification}

  @type period :: :last_24 | :last_week
  @type params :: %{task: String.t()} | %{task: String.t(), note: String.t()}

  @periods [:last_24, :last_week]

  @default_opts [client: Application.fetch_env!(:doit, :todoist_client)]

  @spec create_task(params) :: :ok | {:error, :bad_response}
  @spec create_task(params, keyword) :: :ok | {:error, :bad_response}
  def create_task(params, opts \\ []) when is_map(params) do
    opts = Keyword.merge(@default_opts, opts)

    params
    |> task_to_command()
    |> Client.create_task(opts)
  end

  @spec send_completed_tasks(period) :: :ok | {:error, String.t()}
  @spec send_completed_tasks(period, keyword) :: :ok | {:error, String.t()}
  def send_completed_tasks(period, opts \\ []) when period in @periods do
    opts = Keyword.merge(@default_opts, opts)

    timestamp =
      period
      |> Time.get_datetime()
      |> Time.datetime_to_timestamp()

    with {:ok, response} <- Client.completed_items(timestamp, opts),
         {:ok, tasks} <- CompletedTasks.process(response),
         note <- CompletedTasks.pretty_print(tasks, period),
         params <- %{task: get_text(period), note: note},
         :ok <- create_task(params),
         {:ok, _notification} <- create_notification(%{data: params, type: period}) do
      :ok
    end
  end

  @spec time_to_send_daily_summary?(keyword) :: boolean
  def time_to_send_daily_summary?(opts \\ []) do
    :last_24
    |> Notification.where_type()
    |> Notification.where_created_last_24_hours(opts)
    |> Notification.select_inserted_at()
    |> Repo.one()
    |> case do
      nil -> true
      datetime -> if Time.today?(datetime, opts), do: false, else: true
    end
  end

  @spec time_to_send_weekly_summary?(keyword) :: boolean
  def time_to_send_weekly_summary?(opts \\ []) do
    if Time.monday?(opts) do
      :last_week
      |> Notification.where_type()
      |> Notification.where_created_last_24_hours(opts)
      |> Notification.select_inserted_at()
      |> Repo.one()
      |> case do
        nil -> true
        datetime -> if Time.today?(datetime, opts), do: false, else: true
      end
    else
      false
    end
  end

  defp create_notification(params) do
    params
    |> Notification.changeset()
    |> Repo.insert()
  end

  defp task_to_command(%{task: task, note: note}) do
    item_id = new_uuid()

    [
      %{
        "type" => "item_add",
        "temp_id" => item_id,
        "uuid" => new_uuid(),
        "args" => %{"content" => task, "project_id" => project_id()}
      },
      %{
        "type" => "note_add",
        "temp_id" => new_uuid(),
        "uuid" => new_uuid(),
        "args" => %{"content" => note, "item_id" => item_id}
      }
    ]
  end

  defp task_to_command(%{task: task}) do
    [
      %{
        "type" => "item_add",
        "temp_id" => new_uuid(),
        "uuid" => new_uuid(),
        "args" => %{"content" => task, "project_id" => project_id()}
      }
    ]
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end

  @spec get_text(period) :: String.t()
  defp get_text(:last_24), do: "Last 24 Hours"
  defp get_text(:last_week), do: "Last Week"
end
