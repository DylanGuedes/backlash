defmodule Backlash.UserController do
  use Backlash.Web, :controller

  alias Backlash.User
  alias Backlash.Warden

  plug Warden when action in [:index, :edit, :update]

  def index(conn, _params) do
    users = Repo.all User
    render(conn, "index.html", users: users)
  end

  def new(conn, changeset: changeset),
    do: render(conn, "new.html", changeset: changeset)
  def new(conn, _),
    do: new(conn, changeset: User.changeset(%User{}, %{}))

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Backlash.Auth.login(user)
        |> show(%{"id" => user.id})
      {:error, changeset} ->
        new(conn, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    id = String.to_integer(id)
    if id != conn.assigns[:current_user].id do
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    else
      case Repo.get(User, id) do
        user when is_map(user) ->
          changeset = User.changeset(user, %{})
        render(conn, "edit.html", %{changeset: changeset, user: user})
        _ ->
          redirect(conn, to: page_path(conn, :show, "invalid user"))
      end
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    id_as_int = String.to_integer(id)
    if id_as_int != conn.assigns[:current_user].id do
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    else
      user = Repo.get(User, id)
      changeset = User.changeset(user, user_params)

      case Repo.update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated!")
          |> show(%{"id" => user.id})

        {:error, _} ->
          conn
          |> put_flash(:error, "Invalid attributes!")
          |> edit(%{"id" => id})
      end
    end
  end

  def statistics(conn, _) do
    render(conn, "statistics.html", statistics: [])
  end
end
