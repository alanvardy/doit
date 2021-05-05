defmodule DoitWeb.ParseController do
  use DoitWeb, :controller

  action_fallback DoitWeb.FallbackController

  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t()
  def new(conn, _params) do
    conn |> Plug.Conn.send_resp(200, [])
  end
end
