defmodule Backlash.Project do
  @moduledoc """
  * Project entity

  Entity related to projects.

  ## Examples

      iex> Project.changeset(%Project, %{})
      nil

  """
  use Backlash.Web, :model
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema

  alias Backlash.Repo
  alias Backlash.Project
  alias Backlash.Setup

  @type t :: %Project{}
  @type setup :: %Setup{}

  schema "projects" do
    field :name, :string
    field :description, :string
    field :image, Backlash.ImageUploader.Type

    many_to_many :setups, Backlash.Setup, join_through: "projects_setups"
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> cast_attachments(params, [:image])
  end

  @spec associate_with_setup(t, setup) :: t
  def associate_with_setup(project, setup) do
    project = Repo.preload(project, :setups)
    if (length(project.setups)==0) do
      project
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:setups, [setup])
      |> Repo.update
    else
      project
      |> Ecto.Changeset.change
      |> Ecto.Changeset.cast(%{"setup_id" => setup.id}, [])
      |> Ecto.Changeset.cast_assoc(:setups)
      |> Repo.update
    end
  end

end
