defmodule Backlash.SetupController do
  use Backlash.Web, :controller

  alias Backlash.Setup
  alias Backlash.Repo
  alias Backlash.Project
  alias Backlash.Target

  def index(conn, _) do
    setups = Repo.all(Setup)
    render(conn, "index.html", setups: setups)
  end

  def new(conn, opts = %{changeset: _, project_id: _}) do
    targets = Repo.all(Target)
    opts = Map.put(opts, :targets, targets)
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
    do: render(conn, "show.html", setup: Repo.preload(setup, :projects))
  def show(conn, %{"id" => id}),
    do: show(conn, setup: Repo.get(Setup, id))

end
