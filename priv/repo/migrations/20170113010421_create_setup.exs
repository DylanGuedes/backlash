defmodule Backlash.Repo.Migrations.CreateSetup do
  use Ecto.Migration

  def change do
    create table(:setups) do
      add :name, :string

      timestamps()
    end

    create unique_index(:setups, [:name])
  end
end
