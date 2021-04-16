defmodule Bokken.Repo.Migrations.CreateTeamsMentors do
  use Ecto.Migration

  def change do
    create table(:teams_mentors, primary_key: false) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id), primary_key: true
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id), primary_key: true

      timestamps()
    end

    create index(:teams_mentors, [:team_id])
    create index(:teams_mentors, [:mentor_id])
    create unique_index(:teams_mentors, [:team_id, :mentor_id])
  end
end
