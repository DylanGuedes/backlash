defmodule Backlash.ProjectController do
  use Backlash.Web, :controller

  alias Backlash.Project
  alias Backlash.Repo

  def index(conn, _params) do
    projects = Repo.all(Project)
    render conn, "index.html", projects: projects
  end

  def new(conn, changeset: changeset), do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params), do: new(conn, changeset: Project.changeset(%Project{}, %{}))

  def show(conn, %{"id" => id}) do
    project = Project |> Repo.get(id) |> Repo.preload([{:setups, :target}])
    render(conn, "show.html", project: project)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)
    case Repo.insert(changeset) do
      {:ok, project} ->
        show(conn, %{"id" => project.id})

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

end
