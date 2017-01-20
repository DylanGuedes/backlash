defmodule Backlash.ProjectSetup do
  @moduledoc """
  * Entity take handles the relation between Project and Setup

  ## Usage
      iex> args = %{project_id: 1, setup_id: 1}
      iex> Backlash.ProjectSetup.changeset(%Backlash.ProjectSetup{}, args)
      %Backlash.ProjectSetup{}

  ## Attributes
      * setup_id: Id of the setup of the relationship
      * project_id: Id of the project of the relationship

  """

  use Ecto.Schema

  alias Backlash.ProjectSetup
  alias Backlash.Project
  alias Backlash.Setup
  alias Ecto.Changeset

  @typedoc """
  ProjectSetup struct

  ## Attributes
      * setup_id
      * project_id
  """
  @type t :: %Backlash.ProjectSetup{}

  @primary_key false
  schema "projects_setups" do
    belongs_to :project, Project
    belongs_to :setup, Setup

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    struct
    |> Changeset.cast(params, [:setup_id, :project_id])
    |> Changeset.validate_required([:setup_id, :project_id])
  end
end
