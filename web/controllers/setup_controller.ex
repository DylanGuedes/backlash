defmodule Labyrinth.SetupController do
  use Labyrinth.Web, :controller
  alias Labyrinth.Setup
  alias Labyrinth.Repo

  def index(conn, _) do
    setups = Repo.all(Setup)
    render(conn, "index.html", setups: setups)
  end

  def new(conn, _) do
    changeset = Setup.changeset(%Setup{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"setup" => setup_params}) do
    changeset = Setup.changeset(%Setup{}, setup_params)
    case Repo.insert(changeset) do
      {:ok, stp} ->
        conn
        |> render "show.html", setup: stp
      {:error, changeset} ->
        conn
        |> render "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    stp = Repo.get(Setup, id)
    conn |> render("show.html", setup: stp)
  end

end
