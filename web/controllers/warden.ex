defmodule Backlash.Warden do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Backlash.Router.Helpers

  alias Backlash.User

  def init(opts) do
    opts
  end

  def call(conn, repo) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
