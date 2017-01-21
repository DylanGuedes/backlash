defmodule Backlash.Setup do
  @moduledoc """
  * Entity that stores setups for projects.

  ## Usage
      iex> args = %{name: "a nice setup"}
      iex> Backlash.Setup.changeset(%Backlash.Setup{}, args)
      %Backlash.Setup{}

  ## Attributes
      * target_id
      * projects
      * name
      * script
  """

  use Backlash.Web, :model
  use Ecto.Schema

  alias Backlash.Repo
  alias Backlash.Setup
  alias Backlash.Target
  alias Backlash.ProjectSetup
  alias Backlash.Project

  @typedoc """
  Setup struct

  ## Attributes
      * target_id
      * projects
      * name
      * script
  """
  @type t :: %Setup{}

  schema "setups" do
    field :name, :string
    field :script, :string

    many_to_many :projects, Backlash.Project, join_through: ProjectSetup
    belongs_to :target, Backlash.Target

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:name, :target_id, :script])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> cast_assoc(:target, required: false)
  end

  @spec build :: t
  def build do
    changeset(%Setup{}, %{})
  end

  @spec used_projects_setups(t) :: Ecto.Query.t
  def used_projects_setups(setup) do
    from p in ProjectSetup, where: p.setup_id==^setup.id
  end

  @spec used_projects(t) :: Ecto.Query.t
  def used_projects(setup) do
    from p in used_projects_setups(setup), join: m in Project, on: p.project_id == m.id, select: m
  end

  @spec used_projects_ids(t) :: Ecto.Query.t
  def used_projects_ids(setup) do
    from p in used_projects_setups(setup), select: p.project_id
  end

  @spec unused_projects(t) :: Ecto.Query.t
  def unused_projects(setup) do
    ids = Repo.all(used_projects_ids(setup))
    from p in Project, where: not p.id in ^ids
  end

end
