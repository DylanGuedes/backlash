defmodule Backlash.Repo.Migrations.AddAvatarToProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :image, :string
    end
  end
end
