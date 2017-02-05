defmodule Backlash.Factory do
  use ExMachina.Ecto, repo: Backlash.Repo

  alias Backlash.Project
  alias Backlash.Target
  alias Backlash.Setup
  alias Backlash.User

  def project_factory do
    %Project{
      name: "Noosfero"
    }
  end

  def target_factory do
    %Target{
      name: "Fedora25"
    }
  end

  def setup_factory do
    %Setup{
      name: "Noosfero-for-fedora25",
    }
  end

  def user_factory do
    %User {
      username: "niceuser123",
      password: "nicepass123",
      password_confirmation: "nicepass123",
      email: "bestuser@server.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("nicepass123")
    }
  end
end
