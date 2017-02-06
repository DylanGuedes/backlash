defmodule Backlash.ProjectControllerTest do
  use Backlash.ConnCase

  alias Backlash.Repo
  alias Backlash.Project
  alias Backlash.User

  import Backlash.Factory

  setup do
    user = insert(:user)
    user = Repo.get(User, user.id)
    {:ok, conn: build_conn(), user: user}
  end

  test "GET /projects", %{conn: conn} do
    insert(:project)
    conn = get conn, "/projects"
    assert html_response(conn, 200) =~ "Noosfero"
  end

  test "GET /projects/new without signin", %{conn: conn, user: user} do
    conn = get conn, "/projects/new"
    assert html_response(conn, 302)
  end

  test "GET /projects/new with signin should work", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    conn = get conn, "/projects/new"
    assert html_response(conn, 200)
  end

  test "GET /projects/1", %{conn: conn} do
    project = insert(:project)
    conn = get conn, project_path(conn, :show, project.id)
    assert html_response(conn, 200) =~ "Noosfero"
  end

  test "POST /projects with valid attrs not logged in shouldnt increase count", %{conn: conn, user: user} do
    project_params = params_for(:project)
    l1 = length(Repo.all(Project))
    post conn, project_path(conn, :create, %{"project" => project_params})
    l2 = length(Repo.all(Project))
    assert l1==l2
  end

  test "POST /projects with valid attrs and logged in should work", %{conn: conn, user: user} do
    Repo.delete_all Project
    conn = assign(conn, :current_user, user)
    l1 = User.total_projects_created(user.id)
    project_params = params_for(:project)
    post conn, project_path(conn, :create, %{"project" => project_params})
    l2 = User.total_projects_created(user.id)
    assert l2==l1+1
  end

  test "POST /projects with invalid attrs", %{conn: conn} do
    project_params = %{"name" => "N"}
    l1 = length(Repo.all(Project))
    post conn, project_path(conn, :create, %{"project" => project_params})
    l2 = length(Repo.all(Project))
    assert l1==l2
  end

  test "PUT /projects/1/edit with valid attrs with logged in user", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    project = Repo.insert!(Project.changeset(%Project{}, %{name: "Noosfero", author_id: user.id}))
    name = project.name
    proj_params = %{name: "newname"}
    patch conn, project_path(conn, :update, project, %{"project" => proj_params})
    updated_project = Repo.get(Project, project.id)
    refute updated_project.name==name
  end

  test "GET /projects/1/edit", %{conn: conn, user: user} do
    conn = assign(conn, :current_user, user)
    project = Repo.insert!(Project.changeset(%Project{}, %{name: "Noosfero", author_id: user.id}))
    conn = get(conn, project_path(conn, :edit, project.id))
    assert html_response(conn, 200) =~ "Noosfero"
  end
end
