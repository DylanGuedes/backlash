defmodule Backlash.Repo.Migrations.AddAuthorIdToSetups do
  use Ecto.Migration

  def change do
    alter table(:setups) do
      add :author_id, references(:users)
    end
  end
end
