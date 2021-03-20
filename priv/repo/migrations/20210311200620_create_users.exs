defmodule Bokken.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :role, :string, null: false

      add :verified, :boolean, default: false, null: false
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
