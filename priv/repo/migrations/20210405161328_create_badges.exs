defmodule Bokken.Repo.Migrations.CreateBadges do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :name, :string
      add :description, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:badges, [:name])
  end
end
