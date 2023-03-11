defmodule Bokken.Repo.Migrations.RefactorBotsTable do
  use Ecto.Migration

  def change do
    rename table("bots"), to: table("tokens")

    alter table("tokens") do
      add :description, :string
      add :role, :string, null: false
      modify :api_key, :text, null: true
    end
  end
end
