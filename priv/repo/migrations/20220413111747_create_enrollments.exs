defmodule Bokken.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :ninja_id, references(:ninjas, on_delete: :delete_all, type: :binary_id)
      add :event_id, references(:events, on_delete: :delete_all, type: :binary_id)

      add :notes, :string

      timestamps()
    end

    create index(:enrollments, [:user_id])
    create index(:enrollments, [:lecture_id])
  end
end
