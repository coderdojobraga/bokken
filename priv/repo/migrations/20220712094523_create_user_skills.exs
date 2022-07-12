defmodule Bokken.Repo.Migrations.CreateUserSkills do
  use Ecto.Migration

  def change do
    create table(:user_skills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all, type: :binary_id)
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id)
      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:user_skills, [:mentor_id])
    create index(:user_skills, [:ninja_id])
    create index(:user_skills, [:skill_id])
    create unique_index(:user_skills, [:skill_id, :ninja_id])
    create unique_index(:user_skills, [:skill_id, :mentor_id])

    create(
      constraint(
        :user_skills,
        :ninja_or_mentor,
        check:
          "(mentor_id IS NOT NULL AND ninja_id IS NULL) OR (ninja_id IS NOT NULL AND mentor_id IS NULL)"
      )
    )
  end
end
