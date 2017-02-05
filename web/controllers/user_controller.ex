defmodule Backlash.UserController do
  use Backlash.Web, :controller

  alias Backlash.User

  def index(conn, _params) do
    users = Repo.all User
    render(conn, "index.html", users: users)
  end

  def new(conn, changeset: changeset) do
    render(conn, "new.html", changeset: changeset)
  end
  def new(conn, _) do
    new(conn, changeset: User.changeset(%User{}, %{}))
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        show(conn, %{"id" => user.id})
      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end
end
