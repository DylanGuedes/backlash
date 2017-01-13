defmodule Labyrinth.Repo.Migrations.AssociateProjectsAndSetups do
  use Ecto.Migration

  def change do
    create table(:projects_setups, primary_key: false) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :setup_id, references(:setups, on_delete: :delete_all)
    end
  end
end
