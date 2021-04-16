defmodule Bokken.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:teams, [:name])
  end
end
