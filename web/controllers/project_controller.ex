defmodule Backlash.ProjectController do
  use Backlash.Web, :controller

  alias Backlash.Project
  alias Backlash.Repo

  def index(conn, _params) do
    projects = Repo.all(Project)
    render conn, "index.html", projects: projects
  end

  def edit(conn, %{"id" => id}) do
    case Repo.get(Project, id) do
      project when is_map(project) ->
        changeset = Project.changeset(project, %{})
        render(conn, "edit.html", %{changeset: changeset, project: project})
      _ ->
        redirect conn, to: Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Project.changeset(%Project{}, %{}))

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

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated!")
        |> show(%{"id" => project.id})

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(changeset: changeset)
    end
  end

end
