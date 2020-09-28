defmodule Doit.GitHub.Notification do
  @moduledoc "Notification from GitHub API"

  use TypedStruct

  typedstruct do
    @typedoc @moduledoc

    field :title, String.t(), enforce: true
    field :type, String.t(), enforce: true
    field :url, String.t(), enforce: true
    field :repo, String.t(), enforce: true
  end
end
