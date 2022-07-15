defmodule Bokken.Repo.Migrations.CreateAvailability do
  use Ecto.Migration

  def change do
    create table(:availability, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_available?, :boolean, default: false, null: false
      add :notes, :string

      timestamps()
    end
  end
end
