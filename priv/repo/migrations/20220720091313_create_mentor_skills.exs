defmodule Bokken.Repo.Migrations.CreateMentorSkills do
  use Ecto.Migration

  def change do
    create table(:mentors_skills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all, type: :binary_id)
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:mentors_skills, [:mentor_id])
    create index(:mentors_skills, [:skill_id])
    create unique_index(:mentors_skills, [:skill_id, :mentor_id])
  end
end
