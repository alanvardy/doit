defmodule Doit.GitHub.Response do
  use TypedStruct

  typedstruct do
    @typedoc "A response from the GitHub API"

    field :notifications, [map], enforce: true
    field :headers, [tuple], enforce: true
    field :timestamp, String.t(), enforce: true
    field :poll_interval, pos_integer
  end
end
