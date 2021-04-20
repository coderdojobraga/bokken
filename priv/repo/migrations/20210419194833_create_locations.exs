defmodule Bokken.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :address, :text

      timestamps()
    end

    create unique_index(:locations, [:name])
  end
end
