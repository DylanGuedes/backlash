defmodule Backlash.Target do
  use Backlash.Web, :model
  use Ecto.Schema
  import Ecto.Changeset
  alias Backlash.Repo
  use Arc.Ecto.Schema

  schema "targets" do
    field :name, :string
    field :description, :string
    field :image, Backlash.ImageUploader.Type

    has_many :setups, Backlash.Setup
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
end
