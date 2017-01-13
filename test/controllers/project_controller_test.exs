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
end
