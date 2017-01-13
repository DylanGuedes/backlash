defmodule Labyrinth.ProjectControllerTest do
  use Labyrinth.ConnCase
  alias Labyrinth.Repo
  alias Labyrinth.Project

  test "GET /projects", %{conn: conn} do
    {:ok, _} = Repo.insert(Project.changeset(%Project{}, %{name: "Noosfero"}))
    conn = get conn, "/projects"
    assert html_response(conn, 200) =~ "Noosfero"
  end

  test "GET /projects/new", %{conn: conn} do
    conn = get conn, "/projects/new"
    assert html_response(conn, 200)
  end

  test "GET /projects/1", %{conn: conn} do
    {:ok, proj} = Repo.insert(Project.changeset(%Project{}, %{name: "Noosfero"}))
    conn = get conn, project_path(conn, :show, proj.id)
    assert html_response(conn, 200) =~ "Noosfero"
  end

  test "POST /projects with valid attrs", %{conn: conn} do
    project_params = %{"name" => "Noosfero-for-fedora25"}
    l1 = length(Repo.all(Project))
    post conn, project_path(conn, :create, %{"project" => project_params})
    l2 = length(Repo.all(Project))
    assert l1+1==l2
  end

  test "POST /projects with invalid attrs", %{conn: conn} do
    project_params = %{"name" => "N"}
    l1 = length(Repo.all(Project))
    post conn, project_path(conn, :create, %{"project" => project_params})
    l2 = length(Repo.all(Project))
    assert l1==l2
  end
end
