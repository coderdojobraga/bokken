defmodule Bokken.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :photo, :string
      add :first_name, :string
      add :last_name, :string

      add :email, :string
      add :password_hash, :string
      add :role, :string

      add :verified, :boolean, default: false, null: false
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
