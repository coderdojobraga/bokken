defmodule Bokken.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :email, :citext, null: false
      add :password_hash, :string, null: false
      add :role, :string, null: false

      add :reset_password_token, :string
      add :reset_token_sent_at, :utc_datetime

      add :verified, :boolean, default: false, null: false
      add :active, :boolean, default: false, null: false
      add :registered, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
