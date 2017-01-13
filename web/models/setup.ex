defmodule Backlash.Setup do
  use Backlash.Web, :model

  schema "setups" do
    field :name, :string
    many_to_many :projects, Backlash.Project, join_through: "projects_setups"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
  end

end
