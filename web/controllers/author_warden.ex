defmodule Backlash.AuthorWarden do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Backlash.Router.Helpers

  alias Backlash.User
  alias Backlash.Repo

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    id = Map.fetch!(conn.params, "id")
    handler = Keyword.fetch!(opts, :handler)
    entity = Repo.get(handler, id)

    if conn.assigns.current_user.id == entity.author_id do
      conn
    else
      conn
      |> put_flash(:error, "You are not allowed to do it")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
