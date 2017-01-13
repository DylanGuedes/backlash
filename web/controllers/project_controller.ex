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

end
