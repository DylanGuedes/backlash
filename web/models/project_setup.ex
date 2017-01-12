defmodule Labyrinth.ProjectSetup do
  use Labyrinth.Web, :model
  import Ecto.Changeset

  schema "projects_setups" do
    field :name, :string
    field :description, :string
    has_many :projects_solutions, Labyrinth.Project
    has_many :projects_setups, through: [:projects_solutions, :projects]
    timestamps()
  end

  @required_fields ~w(name description)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
