defmodule Backlash.ProjectSetup do
  use Ecto.Schema

  alias Backlash.ProjectSetup
  alias Backlash.Project
  alias Backlash.Setup

  @primary_key false
  schema "projects_setups" do
    belongs_to :project, Project
    belongs_to :setup, Setup
    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:setup_id, :project_id])
    |> Ecto.Changeset.validate_required([:setup_id, :project_id])
  end
end
