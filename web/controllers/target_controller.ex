defmodule Backlash.TargetController do
  use Backlash.Web, :controller
  alias Backlash.Target
  alias Backlash.Repo

  def index(conn, _) do
    targets = Repo.all(Target)
    render conn, targets: targets
  end

  def new(conn, _) do
    changeset = Target.changeset(%Target{}, %{})
    render conn, changeset: changeset
  end

  def create(conn, %{"target" => target_params}) do
    changeset = Target.changeset(%Target{}, target_params)
    case Repo.insert(changeset) do
      {:ok, target} ->
        conn
        |> render("show.html", target: target)
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
     target = Repo.get(Target, id)
     render conn, "show.html", target: target
  end
end
