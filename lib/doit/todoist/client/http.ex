defmodule Doit.Todoist.Client.HTTP do
  @moduledoc """
  The actual client for GitHub
  """
  alias Tesla.{Client, Env}
  require Logger

  @behaviour Doit.Todoist.Client

  @type resp :: {:ok, %{items: [map], projects: map}} | {:error, :bad_response}

  @base_url "https://api.todoist.com/sync/v8"
  @default_opts [sleep: 0, offset: 0]
  @limit 200
  @timeout 62_000
  @todoist_token Application.compile_env(:doit, :todoist_token)
  @project_id Application.compile_env(:doit, :default_project)

  @spec client :: Client.t()
  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"accept", "Application/json; Charset=utf-8"},
         {"user-agent", "Tesla"}
       ]}
    ]

    adapter = {Tesla.Adapter.Hackney, [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 10000]}
    Tesla.client(middleware, adapter)
  end

  @impl true
  @spec create_task(map) :: :ok | {:error, :bad_response}
  @spec create_task(map, non_neg_integer()) :: :ok | {:error, :bad_response}
  def create_task(commands, retries \\ 0) do
    query = [token: @todoist_token, commands: Jason.encode!([commands])]

    case Tesla.post(client(), "/sync", query: query) do
      {:ok, %Env{status: 200}} ->
        :ok

      {:ok, %Env{status: 400}} = error ->
        if retries < 3 do
          commands
          |> refresh_uuid()
          |> create_task(retries + 1)
        else
          log_error("create_task/1", [commands], error)
          {:error, :bad_response}
        end

      error ->
        log_error("create_task/1", [commands], error)
        {:error, :bad_response}
    end
  end

  @impl true
  @spec completed_items(String.t(), keyword) :: resp

  @spec completed_items(String.t()) :: resp
  def completed_items(timestamp, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    query = [token: @todoist_token, since: timestamp, limit: @limit, offset: opts[:offset]]

    with sleep when sleep < @timeout and is_integer(sleep) <- opts[:sleep],
         :ok <- Process.sleep(sleep),
         response_tuple <- Tesla.post(client(), "/completed/get_all", query: query),
         {:ok, %Env{status: 200, body: body}} <- response_tuple,
         {:ok, %{"items" => items, "projects" => projects}} when length(items) < 200 <- body do
      {:ok, %{items: items, projects: projects}}
    else
      nil ->
        raise "Invalid opts in completed_items/2: #{inspect(opts)}"

      {:ok, %{"items" => _, "projects" => _} = body} ->
        append(body, timestamp, opts)

      error when is_tuple(error) ->
        log_error("completed_items/2", [timestamp, opts], error)
        completed_items(timestamp, Keyword.merge(opts, sleep: (opts[:sleep] + 1000) * 2))

      num when is_integer(num) ->
        Logger.error("completed_items/2 exceeded retry limit")
        {:error, :bad_response}
    end
  end

  @impl true
  def current_tasks do
    query = [token: @todoist_token, project_id: @project_id]

    case Tesla.get(client(), "/projects/get_data", query: query) do
      {:ok, %Env{status: 200, body: %{"items" => items}}} -> {:ok, items}
      error -> log_error("current_tasks/0", [], error)
    end
  end

  defp append(%{"items" => items, "projects" => projects}, timestamp, opts) do
    with {:ok, %{items: new_items}} <-
           completed_items(timestamp, Keyword.merge(opts, offset: opts[:offset] + @limit)) do
      {:ok, %{items: items ++ new_items, projects: projects}}
    end
  end

  defp log_error(function, arguments, error) do
    Logger.error("""
    Error in module: #{inspect(__MODULE__)}
    Function: #{inspect(function)}
    Arguments: #{inspect(arguments)}
    Error: #{inspect(error)}
    """)
  end

  defp refresh_uuid(command) do
    Process.sleep(5000)
    Map.put(command, "uuid", Ecto.UUID.generate())
  end
end
