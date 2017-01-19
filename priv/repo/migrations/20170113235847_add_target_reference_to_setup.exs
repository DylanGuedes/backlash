defmodule Backlash.Repo.Migrations.AddTargetReferenceToSetup do
  use Ecto.Migration

  def change do
    alter table(:setups) do
      add :target_id, references(:targets)
    end
  end
end
