# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule Doit.Todoist.Client.BadResponse do
  @moduledoc """
  Mock client for Todoist
  """
  @behaviour Doit.Todoist.Client

  @impl true
  def create_task(_task), do: {:error, :bad_response}

  @impl true
  def completed_items(arg, _), do: completed_items(arg)

  @impl true
  def completed_items(_), do: {:error, :bad_response}
end
