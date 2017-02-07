defmodule Backlash.SetupController do
  use Backlash.Web, :controller

  alias Backlash.Setup
  alias Backlash.Repo
  alias Backlash.Project
  alias Backlash.Target
  alias Backlash.ProjectSetup
  alias Backlash.Warden
  alias Backlash.AuthorWarden

  plug Warden when action in [:new, :update, :edit, :create]
  plug AuthorWarden, [handler: Setup] when action in [:update, :edit]

  def index(conn, _) do
    setups = Repo.all(from p in Setup, preload: [:projects, :target, :author])
    render(conn, "index.html", setups: setups)
  end

  def new(conn, opts = %{changeset: _, project_id: _}) do
    targets = Repo.all(Target)
    projects = Repo.all(Project)
    opts = opts |> Map.put(:targets, targets) |> Map.put(:projects, projects)
    render(conn, "new.html", opts)
  end
  def new(conn, %{"project_id" => project_id}),
    do: new(conn, %{changeset: Setup.build, project_id: project_id})
  def new(conn, _),
    do: new(conn, %{changeset: Setup.build, project_id: nil})

  def create(conn, %{"setup" => setup_params, "project_id" => project_id}) do
    project = Repo.get(Project, project_id)
    changeset = Setup.changeset(%Setup{}, setup_params)
    case Repo.insert(changeset) do
      {:ok, stp} ->
        {:ok, _} = Project.associate_with_setup(project, stp)
        show(conn, setup: stp)

      {:error, changeset} ->
        new(conn, %{changeset: changeset, project_id: project_id})
    end
  end
  def create(conn, %{"setup" => setup_params}) do
    changeset = Setup.changeset(%Setup{}, setup_params)
    case Repo.insert(changeset) do
      {:ok, stp} ->
        show(conn, setup: stp)

      {:error, changeset} ->
        new(conn, %{changeset: changeset, project_id: nil})
    end
  end

  def show(conn, setup: setup),
    do: render(conn, "show.html", setup: Repo.preload(setup, [:projects, :target]))
  def show(conn, %{"id" => id}),
    do: show(conn, setup: Repo.get(Setup, id))

  def edit(conn, %{"id" => id}) do
    case Repo.get(Setup, id) do
      setup when is_map(setup) ->
        setup = Repo.preload(setup, :projects)
        changeset = Setup.changeset(setup, %{})
        targets = Repo.all(Target)
        projects = Repo.all(Setup.unused_projects(setup))
        render(conn, "edit.html", %{targets: targets, changeset: changeset, setup: setup, projects: projects})
      _ ->
        redirect(conn, to: setup_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "setup" => setup_params}) do
    setup = Repo.get(Setup, id)
    params =
      case Map.has_key?(setup_params, :projects_ids) do
        true ->
          setup_params
        false ->
          Map.merge(%{"projects_ids" => []}, setup_params)
      end

    changeset = Setup.changeset(setup, params)

    case Repo.update(changeset) do
      {:ok, setup} ->
        for proj_id <- params["projects_ids"] do
          proj_setup = ProjectSetup.relate(proj_id, setup.id)
          {:ok, _} = Repo.insert(proj_setup)
        end

        conn
        |> put_flash(:info, "Setup updated!")
        |> show(%{"id" => setup.id})

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid attributes!")
        |> edit(changeset: changeset)
    end
  end

  def derelate(conn, %{"id" => id, "project_id" => project_id}) do
    (from p in ProjectSetup)
    |> where([p], p.project_id == ^project_id)
    |> where([p], p.setup_id == ^id)
    |> Repo.delete_all

    conn
    |> put_flash(:info, "Setup changed")
    |> redirect(to: setup_path(conn, :show, id))
  end
end
