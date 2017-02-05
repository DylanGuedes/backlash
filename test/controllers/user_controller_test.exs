defmodule Backlash.UserControllerTest do
  use Backlash.ConnCase

  alias Backlash.User
  alias Backlash.Repo

  import Backlash.Factory

  setup do
    user = insert(:user)
    user = Repo.get(User, user.id)
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
    conn =
      assign(conn, :current_user, user)
      |> get(user_path(conn, :show, user.id))

    assert html_response(conn, 200) =~ user.username
  end

  test "GET /users/id shouldnot redirect if not logged in", %{conn: conn, user: user} do
    conn = get(conn, user_path(conn, :show, user.id))
    assert html_response(conn, 200)
  end

  test "GET /users/id/edit should work if logged in with correct user", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    conn = get(conn, user_path(conn, :edit, user.id))
    assert html_response(conn, 200)
  end

  test "GET /users/id/edit should not work if not logged in", %{conn: conn, user: _} do
    other = insert(:user, %{username: "otherkkkk", email: "other@other.otherrr"})
    conn = get(conn, user_path(conn, :edit, other.id))
    assert html_response(conn, 302)
  end

  test "GET /users/id/edit should not work for incorrect user", %{conn: conn, user: user} do
    other = insert(:user, %{username: "otherkkkk", email: "other@other.otherrr"})
    conn = assign(conn, :current_user, user)
    conn = get(conn, user_path(conn, :edit, other.id))
    assert html_response(conn, 302)
  end

  test "PUT /users/id/edit should work for correct user", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    user_params = %{username: "new_username"}
    patch conn, user_path(conn, :update, user, %{"id" => user.id, "user" => user_params})
    n_user = Repo.get(User, user.id)
    refute n_user.username==user.username
  end

  test "PUT /users/id/edit shouldnt work if not logged in", %{conn: conn, user: user} do
    user_params = params_for(:user, username: "a new_name")
    patch conn, user_path(conn, :update, user, %{"user" => user_params})
    n_user = Repo.get(User, user.id)
    assert n_user.username==user.username
  end

  test "PUT /users/id/edit shouldnt work for incorrect user", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    other = insert(:user, %{username: "otheruserwork"})
    user_params = %{username: "anothernicename"}
    patch conn, user_path(conn, :update, other, %{"id" => other.id, "user" => user_params})
    n_user = Repo.get(User, other.id)
    assert n_user.username==other.username
  end

end
