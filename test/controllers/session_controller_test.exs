defmodule Backlash.SessionControllerTest do
  use Backlash.ConnCase

  import Backlash.Factory

  alias Backlash.Repo
  alias Backlash.User

  test "GET /signin should work", %{conn: conn} do
    conn = get conn, "/signin"
    assert html_response(conn, 200) =~ "Signin"
  end

  test "POST /session/create should work", %{conn: conn} do
    us = insert(:user)
    session = %{"username" => us.username, "password" => "nicepass123"}
    conn = post(conn, session_path(conn, :create, %{"session" => session}))
    us = Repo.get(User, us.id)
    assert conn.assigns.current_user == us
  end

  test "GET /signout should work", %{conn: conn} do
    us = insert(:user)
    session = %{"username" => us.username, "password" => "nicepass123"}
    conn = post(conn, session_path(conn, :create, %{"session" => session}))
    conn = get(conn, "/signout")
    conn = get(conn, page_path(conn, :index))
    assert conn.assigns.current_user == nil
  end

end
