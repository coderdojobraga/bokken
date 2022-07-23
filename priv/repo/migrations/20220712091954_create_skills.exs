defmodule Bokken.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :citext, null: false
      add :description, :string, null: false, default: ""

      timestamps()
    end

    create unique_index(:skills, [:name])
  end
end
