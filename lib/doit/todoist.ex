defmodule Doit.Todoist do
  @moduledoc """
  All things pertaining to calling the Todoist API and interpreting its output
  """
  alias Doit.{Repo, Time}
  alias Doit.Todoist.{Client, CompletedTasks, Notification}

  @type period :: :last_24 | :last_week
  @type params :: %{task: String.t()} | %{task: String.t(), notes: [String.t()]}

  @periods [:last_24, :last_week]

  @default_opts [client: Application.fetch_env!(:doit, :todoist_client)]

  @spec create_task(params) :: :ok | {:error, :bad_response}
  @spec create_task(params, keyword) :: :ok | {:error, :bad_response}
  def create_task(params, opts \\ []) when is_map(params) do
    opts = Keyword.merge(@default_opts, opts)

    Client.create_task(params, opts)
  end

  @spec get_completed_tasks(period) :: {:ok, [map]} | {:error, :bad_response}
  @spec get_completed_tasks(period, keyword) :: :ok | {:ok, [map]} | {:error, :bad_response}
  def get_completed_tasks(period, opts \\ []) when period in @periods do
    opts = Keyword.merge(@default_opts, opts)

    timestamp =
      period
      |> Time.get_datetime()
      |> Time.datetime_to_timestamp()

    with {:ok, response} <- Client.completed_items(timestamp, opts),
         {:ok, tasks} <- CompletedTasks.process(response),
         notes <- CompletedTasks.pretty_print(tasks),
         params <- %{task: get_text(period), notes: notes},
         {:ok, _notification} <- create_notification(%{data: params, type: period}) do
      {:ok, task_to_command(params)}
    end
  end

  @spec time_to_send_daily_summary?(keyword) :: boolean
  def time_to_send_daily_summary?(opts \\ []) do
    :last_24
    |> Notification.where_type()
    |> Notification.where_created_last_24_hours(opts)
    |> Notification.order_by_inserted_at()
    |> Notification.select_inserted_at()
    |> Repo.all()
    |> case do
      [] -> true
      [datetime | _] -> if Time.today?(datetime, opts), do: false, else: true
    end
  end

  @spec time_to_send_weekly_summary?(keyword) :: boolean
  def time_to_send_weekly_summary?(opts \\ []) do
    if Time.monday?(opts) do
      :last_week
      |> Notification.where_type()
      |> Notification.where_created_last_24_hours(opts)
      |> Notification.order_by_inserted_at()
      |> Notification.select_inserted_at()
      |> Repo.all()
      |> case do
        [] -> true
        [datetime | _] -> if Time.today?(datetime, opts), do: false, else: true
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

  @spec task_to_command(%{task: String.t()}) :: [String.t()]
  @spec task_to_command(%{task: String.t(), notes: [String.t()]}) :: [map]
  def task_to_command(%{task: task, notes: notes}) do
    item_id = new_uuid()

    [
      %{
        "type" => "item_add",
        "temp_id" => item_id,
        "uuid" => new_uuid(),
        "args" => %{
          "content" => "#{task} #{default_tags()}",
          "priority" => 2,
          "project_id" => project_id(),
          "auto_parse_labels" => true
        }
      }
      | for note <- notes do
          %{
            "type" => "note_add",
            "temp_id" => new_uuid(),
            "uuid" => new_uuid(),
            "args" => %{"content" => note, "item_id" => item_id}
          }
        end
    ]
  end

  def task_to_command(%{task: task}) do
    [
      %{
        "type" => "item_add",
        "temp_id" => new_uuid(),
        "uuid" => new_uuid(),
        "args" => %{
          "content" => "#{task} #{default_tags()}",
          "priority" => 2,
          "project_id" => project_id()
        }
      }
    ]
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.fetch_env!(:doit, :default_project)
  end

  defp default_tags do
    Application.get_env(:doit, :default_tags, "")
  end

  @spec get_text(period) :: String.t()
  defp get_text(:last_24), do: "Last 24 Hours"
  defp get_text(:last_week), do: "Last Week"
end
