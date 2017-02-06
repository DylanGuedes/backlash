defmodule Backlash.AdminController do
  use Backlash.Web, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
