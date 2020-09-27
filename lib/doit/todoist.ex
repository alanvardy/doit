defmodule Doit.Todoist do
  alias HTTPoison.Response
  @create_task_url "https://api.todoist.com/sync/v8/sync"
  def create_tasks(tasks) when is_list(tasks) do
    headers = [Accept: "Application/json; Charset=utf-8"]

    commands =
      tasks
      |> Enum.map(fn task ->
        %{
          "type" => "item_add",
          "temp_id" => new_uuid(),
          "uuid" => new_uuid(),
          "args" => %{"content" => task, "project_id" => project_id()}
        }
      end)
      |> Jason.encode!()

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      recv_timeout: 5000,
      params: [token: todoist_token(), commands: commands]
    ]

    case HTTPoison.post(
           @create_task_url,
           "",
           headers,
           options
         ) do
      {:ok, %Response{status_code: 200, body: body}} -> {:ok, Jason.decode!(body)}
      _ -> {:error, :bad_response}
    end
  end

  def mock_response(_task) do
    {:ok,
     %{
       "full_sync" => true,
       "sync_status" => %{"4c3532c3-a1d8-425f-8bce-691fd695db76" => "ok"},
       "sync_token" =>
         "rkAreOey1TYNzCeoxP2gA-GAZPBPHM37UVkVy88UQj2AV4wy8QiUvaYuEd3KUsNkAAikRaW_xoxOCpEwwG37iLvyiGtAxmchXFL9HJq8RziIA9k",
       "temp_id_mapping" => %{"194a2cb2-093a-404f-80f4-620c1d0fb0e5" => 4_207_489_567}
     }}
  end

  defp new_uuid do
    Ecto.UUID.generate()
  end

  defp project_id do
    Application.get_env(:doit, :default_project)
  end

  defp todoist_token do
    Application.get_env(:doit, :todoist_token)
  end
end
