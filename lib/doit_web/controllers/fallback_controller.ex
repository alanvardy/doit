defmodule DoitWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use DoitWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  @spec call(Plug.Conn.t(), {:error, Ecto.Changeset.t() | :not_found}) :: Plug.Conn.t()
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DoitWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DoitWeb.ErrorView)
    |> render(:"404")
  end
end
