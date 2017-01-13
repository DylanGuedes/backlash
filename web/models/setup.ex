defmodule Labyrinth.Setup do
  use Labyrinth.Web, :model

  schema "setups" do
    field :name, :string
    many_to_many :projects, Labyrinth.Project, join_through: "projects_setups"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
