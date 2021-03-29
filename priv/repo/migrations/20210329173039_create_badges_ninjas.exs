defmodule Bokken.Repo.Migrations.CreateBadgesNinjas do
  use Ecto.Migration

  def change do
    create table(:badges_ninjas, primary_key: false) do
      add :badge_id, references(:badges, on_delete: :nothing, type: :id), primary_key: true
      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id), primary_key: true

      timestamps()
    end

    create index(:badges_ninjas, [:badge_id])
    create index(:badges_ninjas, [:ninja_id])
  end
end
