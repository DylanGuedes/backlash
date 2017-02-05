defmodule Backlash.UserControllerTest do
  use Backlash.ConnCase

  alias Backlash.User
  alias Backlash.Repo

  import Backlash.Factory

  setup do
    user = insert(:user)
    {:ok, conn: build_conn(), user: user}
  end

  test "GET /users should work", %{conn: _, user: user} do
    conn = assign(build_conn(), :current_user, user) |> get("/users")
    assert html_response(conn, 200) =~ user.username
  end

  test "GET /users/new should work", %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200) =~ "Signup"
  end

  test "POST /users/new should work with valid attrs", %{conn: conn} do
    Repo.delete_all User
    user_params = params_for(:user)
    post conn, user_path(conn, :create, %{"user" => user_params})

    q = from p in User, select: count(p.id)
    l2 = Repo.one(q)
    assert l2==1
  end

  test "POST /users/new should not create with invalid attrs", %{conn: conn, user: _} do
    user_params = params_for(:user, %{username: "k"})
    q = from p in User, select: count(p.id)
    post conn, user_path(conn, :create, %{"user" => user_params})
    l2 = Repo.one(q)
    assert l2==1
  end

  test "GET /users/id should work while logged in", %{conn: conn, user: user} do
    us = user
    conn =
      assign(build_conn(), :current_user, us)
      |> get(user_path(conn, :show, us.id))

    assert html_response(conn, 200) =~ us.username
  end

  test "GET /users/id should redirect if not logged in", %{conn: conn, user: user} do
    conn = get(conn, user_path(conn, :show, user.id))
    assert html_response(conn, 302)
  end
end
