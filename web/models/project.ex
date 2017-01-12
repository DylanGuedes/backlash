defmodule Labyrinth.Project do
  use Labyrinth.Web, :model
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string
    has_many :projects_solutions, Labyrinth.ProjectSolution
    has_many :projects_setups, through: [:projects_solutions, :projects_setups]
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
