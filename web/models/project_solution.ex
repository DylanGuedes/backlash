defmodule Labyrinth.ProjectSolution do
  use Labyrinth.Web, :model
  import Ecto.Changeset

  schema "projects_solutions" do
    belongs_to :project, Labyrinth.Project
    belongs_to :project_setup, Labyrinth.ProjectSetup
    timestamps()
  end

  @required_fields ~w(name description)
  @optional_fields ~w(email name)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
