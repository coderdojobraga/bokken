defmodule Bokken.Repo.Migrations.CreateGuardians do
  use Ecto.Migration

  def change do
    create table(:guardians, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :photo, :string
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :mobile, :string, null: false
      add :city, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:guardians, [:user_id])
  end
end
