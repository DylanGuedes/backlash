defmodule Backlash.Project do
  @moduledoc """
  * Entity that stores projects.

  ## Usage

      iex> Backlash.Project.changeset(%Backlash.Project, %{name: "Noosfero"})
      nil

  ## Attributes
      * name: Name of the project
      * description: Description of the project
      * image: Image related to the project
      * setups: Relationship m:n with setups

  """

  use Backlash.Web, :model
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Backlash.Repo
  alias Backlash.Setup
  alias Backlash.ProjectSetup
  alias Backlash.User
  alias Backlash.Project
  alias Backlash.Reputation

  @typedoc """
  Project struct

  ## Attributes
      * name
      * description
      * image
      * setups
  """
  @type t :: %Backlash.Project{}

  schema "projects" do
    field :name, :string
    field :description, :string
    field :image, Backlash.ImageUploader.Type

    many_to_many :setups, Backlash.Setup, join_through: ProjectSetup
    has_many :reputations, Reputation
    belongs_to :author, User

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:name, :description, :author_id])
    |> validate_required([:name])
    |> assoc_constraint(:author)
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> validate_length(:description, [max: 2000])
    |> cast_attachments(params, [:image])
  end

  @spec associate_with_setup(t, Setup.t) :: t
  def associate_with_setup(project, setup) do
    opt = %{project_id: project.id, setup_id: setup.id}
    changeset = ProjectSetup.changeset(%ProjectSetup{}, opt)
    Repo.insert(changeset)
  end

  @spec total_setups(integer) :: number
  def total_setups(project_id) do
    q = from p in ProjectSetup, where: p.project_id==^project_id, select: count(p.setup_id)
    Repo.one q
  end

  @spec can_edit?(t, User.t) :: boolean
  def can_edit?(%Project{author_id: id}, %User{id: id}),
    do: true
  def can_edit?(project, %User{admin: true}),
    do: true
  def can_edit?(project, user),
    do: false

  @spec can_delete?(t, User.t) :: boolean
  def can_delete?(%Project{author_id: id}, %User{id: id}),
    do: true
  def can_delete?(project, %User{admin: true}),
    do: true
  def can_delete?(project, user),
    do: false

  @spec stars(t) :: number
  def stars(project) do
    q = from p in Reputation, where: p.project_id==^project.id, select: count(p.id)
    Repo.one q
  end
end
