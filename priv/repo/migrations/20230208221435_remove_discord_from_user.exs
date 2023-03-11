defmodule Bokken.Repo.Migrations.RemoveDiscordFromUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :discord_id
    end
  end
end
