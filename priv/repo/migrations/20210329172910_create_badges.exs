defmodule Bokken.Repo.Migrations.CreateBadges do
  use Ecto.Migration

  def change do
    create table(:badges, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :description, :string
      add :photo, :string

      timestamps()
    end

    create unique_index(:badges, [:name])
  end
end
