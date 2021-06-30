defmodule Doit.GitHub.Client.BadResponse do
  @moduledoc """
  Mock client for GitHub
  """
  @behaviour Doit.GitHub.Client

  @impl true
  def notifications, do: {:error, :bad_response}

  @impl true
  def pull_merge_status(_url), do: {:ok, :open}

  @impl true
  def clear_notifications(_timestamp), do: {:error, :bad_response}
end
