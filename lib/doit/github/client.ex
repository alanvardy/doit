defmodule Doit.GitHub.Client do
  alias GitHub.Response
  @callback notifications :: {:ok, Response.t()} | {:error, :bad_response}
end
