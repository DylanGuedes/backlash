defmodule Backlash.Repo.Migrations.AddScriptToSetup do
  use Ecto.Migration

  def change do
    alter table(:setups) do
      add :script, :text
    end
  end
end
