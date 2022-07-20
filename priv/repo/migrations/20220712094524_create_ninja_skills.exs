defmodule Bokken.Repo.Migrations.CreateNinjaSkills do
  use Ecto.Migration

  def change do
    create table(:ninja_skills, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all, type: :binary_id)
      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:ninja_skills, [:ninja_id])
    create index(:ninja_skills, [:skill_id])
    create unique_index(:ninja_skills, [:skill_id, :ninja_id])
  end
end
