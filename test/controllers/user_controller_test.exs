defmodule Backlash.UserControllerTest do
  use Backlash.ConnCase

  alias Backlash.User
  alias Backlash.Repo

  import Backlash.Factory

  test "GET /users should work", %{conn: conn} do
    us = insert(:user)
    conn = assign(build_conn(), :current_user, us) |> get("/users")
    assert html_response(conn, 200) =~ us.username
  end

  test "GET /users/new should work", %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200) =~ "Signup"
  end

  test "POST /users/new should work with valid attrs", %{conn: conn} do
    q = from p in User, select: count(p.id)
    l1 = Repo.one(q)
    assert l1==0
    user_params = params_for(:user)
    post conn, user_path(conn, :create, %{"user" => user_params})
    l2 = Repo.one(q)
    assert l2==(l1+1)
  end

  test "POST /users/new should not create with invalid attrs", %{conn: conn} do
    q = from p in User, select: count(p.id)
    l1 = Repo.one(q)
    assert l1==0
    user_params = params_for(:user, %{username: "k"})
    post conn, user_path(conn, :create, %{"user" => user_params})
    l2 = Repo.one(q)
    assert l2==(l1+0)
  end

  test "GET /users/id should work while logged in", %{conn: conn} do
    us = insert(:user)
    conn =
      assign(build_conn(), :current_user, us)
      |> get(user_path(conn, :show, us.id))

    assert html_response(conn, 200) =~ us.username
  end

  test "GET /users/id should redirect if not logged in", %{conn: conn} do
    us = insert(:user)
    conn = get(conn, user_path(conn, :show, us.id))
    assert html_response(conn, 302)
    IO.inspect conn.request_path
  end
end
