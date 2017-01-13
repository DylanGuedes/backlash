defmodule Backlash.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :description, :string
      timestamps()
    end

    create unique_index(:projects, [:name])
  end
end
