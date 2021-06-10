defmodule Bokken.Repo.Migrations.CreateBadges do
  use Ecto.Migration

  def change do
    create table(:badges, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :description, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:badges, [:name])
  end
end
