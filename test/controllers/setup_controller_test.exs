defmodule Backlash.SetupControllerTest do
  use Backlash.ConnCase

  import Backlash.Factory

  alias Backlash.Repo
  alias Backlash.Setup
  alias Backlash.Project
  alias Backlash.User

  setup do
    user = insert(:user)
    user = Repo.get(User, user.id)
    {:ok, conn: build_conn(), user: user}
  end

  test "GET /setups", %{conn: conn} do
    insert(:setup)
    conn = get conn, "/setups"
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "GET /setups/new", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    conn = get conn, "/setups/new"
    assert html_response(conn, 200)
  end

  test "GET /projects/1", %{conn: conn} do
    target = insert(:target)
    {:ok, stp} = target |> Ecto.build_assoc(:setups, params_for(:setup)) |> Repo.insert
    conn = get conn, setup_path(conn, :show, stp.id)
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "POST /setups with valid attrs", %{conn: conn, user: user} do
    l1 = length(Repo.all(Setup))
    conn = assign(conn, :current_user, user)
    post conn, setup_path(conn, :create, %{"setup" => params_for(:setup)})
    l2 = length(Repo.all(Setup))
    assert l1+1==l2
  end

  test "POST /setups with valid attrs and relationship", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    proj = insert(:project) |> Repo.preload(:setups)
    setup_params = params_for(:setup)
    l1 = length(Repo.all(Setup))
    r1 = length(proj.setups)

    post conn, setup_path(conn, :create, %{"setup" => setup_params, "project_id" => proj.id})
    assert length(Repo.all(Setup))==l1+1
    proj = Project |> Repo.get(proj.id) |> Repo.preload(:setups)
    assert length(proj.setups)==r1+1
  end

  test "POST /setups with invalid attrs and logged in", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    setup_params = %{"name" => "N"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1==(l2)
  end

  test "POST /setups with invalid attrs and not logged in", %{conn: conn} do
    setup_params = %{"name" => "N"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1==(l2)
  end

  test "PUT /setups/1/edit with valid attrs", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    stp = insert(:setup, %{author_id: user.id})
    name = stp.name
    setup_params = params_for(:setup, name: "a new_setup")
    patch conn, setup_path(conn, :update, stp, %{"setup" => setup_params})
    updated_setup = Repo.get(Setup, stp.id)
    refute updated_setup.name==name
  end

  test "GET /projects/1/edit", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    stp = insert(:setup, %{author_id: user.id})
    conn = get(conn, setup_path(conn, :edit, stp))
    assert html_response(conn, 200) =~ "Noosfero"
  end
end
