defmodule Backlash.Factory do
  use ExMachina.Ecto, repo: Backlash.Repo

  alias Backlash.Project
  alias Backlash.Repo
  alias Backlash.Target
  alias Backlash.Setup

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
end
