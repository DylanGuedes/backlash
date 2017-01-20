defmodule Backlash.Setup do
  @moduledoc """
  Setup examples:
  -> elixir-for-fedora25-script
  -> postgres-for-ubuntu-script
  """
  use Backlash.Web, :model

  alias Backlash.Repo
  alias Backlash.Setup
  alias Backlash.Target

  @type setup :: %Setup{}

  schema "setups" do
    field :name, :string
    many_to_many :projects, Backlash.Project, join_through: "projects_setups"
    belongs_to :target, Backlash.Target
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :target_id])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> cast_assoc(:target, required: false)
  end

  @spec link_to_target(setup, number) :: Setup
  def link_to_target(me, target_id) do
    target = Target |> Repo.get(target_id) |> Repo.preload(:setups)

    me
    |> Repo.preload(:target)
    |> Ecto.Changeset.cast(%{target: target}, [])
    |> Ecto.Changeset.put_assoc(:target, target)
    |> Repo.update!
  end

  def build do
    changeset(%Setup{}, %{})
  end

end
