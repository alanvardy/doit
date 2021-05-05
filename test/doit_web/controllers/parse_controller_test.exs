defmodule DoitWeb.ParseControllerTest do
  use DoitWeb.ConnCase

  describe "new" do
    test "new", %{conn: conn} do
      conn = post(conn, Routes.parse_path(conn, :new))
      assert response(conn, 200)
    end
  end
end
