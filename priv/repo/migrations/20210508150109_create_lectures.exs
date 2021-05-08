defmodule Bokken.Repo.Migrations.CreateLectures do
  use Ecto.Migration

  def change do
    create table(:lectures, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :summary, :text
      add :notes, :text
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id)
      add :event_id, references(:events, on_delete: :nothing, type: :binary_id)
      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:lectures, [:mentor_id])
    create index(:lectures, [:event_id])
    create index(:lectures, [:ninja_id])
  end
end
