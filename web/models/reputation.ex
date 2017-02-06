defmodule Backlash.Reputation do
  @moduledoc """
  * Entity that stores reputation related to entities.

  ## Usage

  # TODO
      iex> Backlash.Project.changeset(%Backlash.Project, %{name: "Noosfero"})
      nil

  ## Attributes
      * name: Name of the project
      * description: Description of the project
      * image: Image related to the project
      * setups: Relationship m:n with setups

  """

  @typedoc """
  Reputation struct

  ## Attributes
      * user_id (required)
      * project_id (optional)
  """
  @type t :: %Backlash.Reputation{}

  use Backlash.Web, :model

  alias Backlash.User
  alias Backlash.Project

  schema "reputations" do
    belongs_to :user, User
    belongs_to :project, Project

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :project_id])
    |> validate_required([:user_id])
  end

end
