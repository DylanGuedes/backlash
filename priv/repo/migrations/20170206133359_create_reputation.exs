defmodule Backlash.Repo.Migrations.CreateReputation do
  use Ecto.Migration

  def change do
    create table(:reputations) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :user_id, references(:setups, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:reputations, [:user_id, :project_id])
  end
end
