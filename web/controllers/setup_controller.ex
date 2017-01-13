defmodule Backlash.SetupController do
  use Backlash.Web, :controller
  alias Backlash.Setup
  alias Backlash.Repo
  alias Backlash.Project

  def index(conn, _) do
    setups = Repo.all(Setup)
    render(conn, "index.html", setups: setups)
  end

  def new(conn, params) do
    changeset = Setup.changeset(%Setup{}, %{})
    render(conn, "new.html", %{ changeset: changeset, project_id: params["project_id"] })
  end

  def create(conn, %{"setup" => setup_params, "project_id" => project_id}) do
    project = Repo.get(Project, project_id) |> Repo.preload(:setups)
    changeset = Setup.changeset(%Setup{}, setup_params)
    case Repo.insert(changeset) do
      {:ok, stp} ->
        Project.push_setup(project, stp)

        conn
        |> render("show.html", setup: Repo.preload(stp, :projects))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
  def create(conn, %{"setup" => setup_params}) do
    changeset = Setup.changeset(%Setup{}, setup_params)
    case Repo.insert(changeset) do
      {:ok, stp} ->

        conn
        |> render("show.html", setup: Repo.preload(stp, :projects))
      {:error, changeset} ->
        conn
        |> render("new.html", %{changeset: changeset, project_id: nil})
    end
  end

  def show(conn, %{"id" => id}) do
    stp = Repo.get(Setup, id) |> Repo.preload(:projects)
    conn |> render("show.html", setup: stp)
  end

end
