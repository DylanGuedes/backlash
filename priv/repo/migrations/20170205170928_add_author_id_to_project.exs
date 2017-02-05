defmodule Backlash.Repo.Migrations.AddAuthorIdToProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :author_id, references(:users)
    end
  end
end
