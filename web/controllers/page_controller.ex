defmodule Backlash.PageController do
  use Backlash.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
