# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule Doit.Todoist.Client.BadResponse do
  @moduledoc """
  Mock client for Todoist
  """
  @behaviour Doit.Todoist.Client

  def create_task(_task), do: {:error, :bad_response}
  def completed_items(_), do: {:error, :bad_response}
end
