defmodule Backlash.Image do
  use Backlash.Web, :model
  use Arc.Ecto.Schema

  schema "images" do
    field :image, Backlash.ImageUploader.Type
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image])
    |> cast_attachments(params, [:image])
  end

end
