defmodule Backlash.Target do
  @moduledoc """
  * Entity take stores the target for a given setup

  ## Usage
      iex> args = %{name: "Fedora 25"}
      iex> Backlash.Target.changeset(%Backlash.Target{}, args)
      %Backlash.Target{}

  ## Attributes
      * name
      * description
      * image

  """
  use Backlash.Web, :model
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Backlash.Repo
  @typedoc """
  Target struct

  ## Attributes
      * name
      * description
      * image
  """
  @type t :: %Backlash.Target{}

  schema "targets" do
    field :name, :string
    field :description, :string
    field :image, Backlash.ImageUploader.Type

    has_many :setups, Backlash.Setup

    timestamps()
  end

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, [min: 3, max: 120])
    |> cast_attachments(params, [:image])
  end
end
