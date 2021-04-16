defmodule Bokken.Repo.Migrations.CreateTeamsNinjas do
  use Ecto.Migration

  def change do
    create table(:teams_ninjas, primary_key: false) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id), primary_key: true
      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id), primary_key: true

      timestamps()
    end

    create index(:teams_ninjas, [:team_id])
    create index(:teams_ninjas, [:ninja_id])
    create unique_index(:teams_ninjas, [:team_id, :ninja_id])
  end
end
