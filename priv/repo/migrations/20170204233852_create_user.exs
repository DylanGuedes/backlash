defmodule Backlash.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password_hash, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:username, :email])
  end
end
