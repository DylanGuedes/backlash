defmodule Labyrinth.ProjectController do

  use Labyrinth.Web, :controller
  alias Labyrinth.Project
  alias Labyrinth.Repo

  def index(conn, _params) do
    projects = Repo.all(Project)
    render conn, "index.html", projects: projects
  end

  def new(conn, _params) do
    changeset = Project.changeset(%Project{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    render conn, "show.html", project: project
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)
    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> render("show.html", project: project)

      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

end
