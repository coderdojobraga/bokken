defmodule Bokken.Repo.Migrations.CreateNinjas do
  use Ecto.Migration

  def change do
    create table(:ninjas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :photo, :string
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :birthday, :date, null: false
      add :belt, :string
      add :notes, :text
      add :social, {:array, :map}, default: []
      add :guardian_id, references(:guardians, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:ninjas, [:guardian_id])
    create index(:ninjas, [:user_id])
  end
end
