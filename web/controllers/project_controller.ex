defmodule Backlash.ProjectController do
  use Backlash.Web, :controller

  alias Backlash.Project
  alias Backlash.Repo
  alias Backlash.Warden
  alias Backlash.AuthorWarden
  alias Backlash.User

  plug Warden when action in [:new, :update, :edit, :create, :repute, :unrepute]
  plug AuthorWarden, [handler: Project] when action in [:update, :edit]

  def index(conn, _params) do
    q = from p in Project, preload: :author
    projects = Repo.all q
    render conn, "index.html", projects: projects
  end

  def edit(conn, %{"id" => id}) do
    case Repo.get(Project, id) do
      project when is_map(project) ->
        changeset = Project.changeset(project, %{})
        render(conn, "edit.html", %{changeset: changeset, project: project})
      _ ->
        redirect conn, to: Backlash.Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _params),
    do: new(conn, changeset: Project.changeset(%Project{}, %{}))

  def show(conn, %{"id" => id}) do
    project = Project |> Repo.get(id) |> Repo.preload([{:setups, :target}, :author])
    render(conn, "show.html", project: project)
  end

  def create(conn, %{"project" => project_params}) do
    user = conn.assigns[:current_user]
    opts = Map.put(project_params, "author_id", user.id)
    changeset = Project.changeset(%Project{}, opts)

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

  def repute(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    if User.can_repute?(user.id, id) do
      {:ok, _} = User.repute_project(user.id, id)
      redirect(conn, to: project_path(conn, :index))
    else
      redirect(conn, to: project_path(conn, :index))
    end
  end

  def unrepute(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    if User.reputed?(user.id, id) do
      {:ok, _} = User.unrepute_project(user.id, id)
      redirect(conn, to: project_path(conn, :index))
    else
      redirect(conn, to: project_path(conn, :index))
    end
  end

  def setups(conn, %{"id" => id}) do
    query = from p in Project, where: p.id==^id, preload: [{:setups, :target}, :author]
    project = Repo.one query
    render(conn, "setups.html", project: project)
  end
end
