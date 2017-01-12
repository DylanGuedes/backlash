defmodule Labyrinth.ProjectController do

  use Labyrinth.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
