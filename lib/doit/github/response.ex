defmodule Doit.GitHub.Response do
  @moduledoc "Response from GitHub API"

  use TypedStruct

  typedstruct do
    @typedoc @moduledoc

    # A list of notifications
    field :notifications, [map], enforce: true
    # Headers from the response
    field :headers, [tuple], enforce: true
    # Notifications up until this time were fetched
    field :timestamp, String.t(), enforce: true
    # Milliseconds before the next request to GitHub should take place
    field :poll_interval, pos_integer
  end
end
