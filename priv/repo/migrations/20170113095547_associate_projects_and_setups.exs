defmodule Backlash.Repo.Migrations.AssociateProjectsAndSetups do
  use Ecto.Migration

  def change do
    create table(:projects_setups, primary_key: false) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :setup_id, references(:setups, on_delete: :delete_all)
      timestamps()
    end
    create unique_index(:projects_setups, [:project_id, :setup_id])
  end
end
