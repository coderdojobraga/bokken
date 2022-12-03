defmodule Bokken.Repo.Migrations.CreateBot do
  use Ecto.Migration

  def change do
    create table(:bots, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :api_key, :string, null: false

      timestamps()
    end
  end
end
