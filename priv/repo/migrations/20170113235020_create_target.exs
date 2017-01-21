defmodule Backlash.Repo.Migrations.CreateTarget do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :name, :string
      add :description, :text
      add :image, :string

      timestamps()
    end
    create unique_index(:targets, [:name])
  end
end
