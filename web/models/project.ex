defmodule Labyrinth.Project do
  use Labyrinth.Web, :model
  use Ecto.Schema
  import Ecto.Changeset
  alias Labyrinth.Repo

  schema "projects" do
    field :name, :string
    field :description, :string
    many_to_many :setups, Labyrinth.Setup, join_through: "projects_setups"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
  end

  def push_setup(project, setup) do
    project = Repo.preload(project, :setups)
    setup = Repo.preload(setup, :projects)

    project
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:setups, [setup | project.setups])
    |> Repo.update
  end
end
