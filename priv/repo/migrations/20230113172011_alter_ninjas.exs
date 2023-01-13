defmodule Bokken.Repo.Migrations.AlterNinjas do
  use Ecto.Migration

  def change do
    alter table(:ninjas, primary_key: false) do
      add :codemonkey, :string
      add :lightbot, :string
      add :codewars, :string
    end
  end
end
