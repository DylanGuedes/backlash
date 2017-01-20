defmodule Backlash.TargetController do
  use Backlash.Web, :controller

  alias Backlash.Target
  alias Backlash.Repo

  def index(conn, _) do
    targets = Repo.all(Target)
    render(conn, "index.html", targets: targets)
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _),
    do: new(conn, changeset: Target.changeset(%Target{}, %{}))

  def create(conn, %{"target" => target_params}) do
    changeset = Target.changeset(%Target{}, target_params)
    case Repo.insert(changeset) do
      {:ok, target} ->
        show(conn, target: target)

      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, target: target),
    do: render(conn, "show.html", target: Repo.preload(target, :setups))
  def show(conn, %{"id" => id}),
    do: show(conn, target: Target |> Repo.get(id))
end
