defmodule Bokken.Repo.Migrations.CreateLecturesMentorsAssistants do
  use Ecto.Migration

  def change do
    create table(:lectures_mentors_assistants, primary_key: false) do
      add :lecture_id, references(:lectures, on_delete: :nothing, type: :binary_id)
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:lectures_mentors_assistants, [:lecture_id])
    create index(:lectures_mentors_assistants, [:mentor_id])
  end
end
