defmodule Backlash.SessionControllerTest do
  use Backlash.ConnCase
  alias Backlash.Repo
  alias Backlash.Project

  import Backlash.Factory

  test "GET /sessions/new", %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert html_response(conn, 200) =~ "Signin"
  end
end
