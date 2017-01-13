defmodule Labyrinth.SetupControllerTest do
  use Labyrinth.ConnCase
  alias Labyrinth.Repo
  alias Labyrinth.Setup
  alias Labyrinth.Project

  test "GET /setups", %{conn: conn} do
    {:ok, _} = Repo.insert(Setup.changeset(%Setup{}, %{name: "Noosfero-for-fedora25"}))
    conn = get conn, "/setups"
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "GET /setups/new", %{conn: conn} do
    conn = get conn, "/setups/new"
    assert html_response(conn, 200)
  end

  test "GET /projects/1", %{conn: conn} do
    {:ok, setup} = Repo.insert(Setup.changeset(%Setup{}, %{name: "Noosfero-for-fedora25"}))
    conn = get conn, setup_path(conn, :show, setup.id)
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "POST /setups with valid attrs", %{conn: conn} do
    setup_params = %{"name" => "Noosfero-for-fedora25"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1+1==l2
  end

  test "POST /setups with valid attrs and relationship", %{conn: conn} do
    proj = Repo.insert!(Project.changeset(%Project{}, %{name: "Noosfero", description: "A nice community"}))
            |> Repo.preload(:setups)

    setup_params = %{"name" => "Noosfero-for-fedora25"}
    l1 = length(Repo.all(Setup))
    r1 = length(proj.setups)
    post conn, setup_path(conn, :create, %{"setup" => setup_params, "project_id" => proj.id})
    l2 = length(Repo.all(Setup))
    assert l1+1==l2

    proj = Repo.get(Project, proj.id) |> Repo.preload(:setups)
    assert length(proj.setups)==r1+1
  end

  test "POST /setups with invalid attrs", %{conn: conn} do
    setup_params = %{"name" => "N"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1==(l2)
  end
end
