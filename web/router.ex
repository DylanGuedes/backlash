defmodule Backlash.Router do
  use Backlash.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Backlash.Auth, repo: Backlash.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Backlash do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/users/statistics", UserController, :statistics
    resources "/projects", ProjectController
    resources "/setups", SetupController
    resources "/targets", TargetController
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:create]
    resources "/admin", AdminController, only: [:index]

    get "/projects/:id/repute", ProjectController, :repute
    get "/projects/:id/unrepute", ProjectController, :unrepute
    get "/projects/:id/setups", ProjectController, :setups

    get "/signout", SessionController, :delete
    get "/signin", SessionController, :new
    get "/signup", UserController, :new

    get "/setups/:id/derelate/:project_id", SetupController, :derelate
  end

  # Other scopes may use custom stacks.
  # scope "/api", Backlash do
  #   pipe_through :api
  # end
end
