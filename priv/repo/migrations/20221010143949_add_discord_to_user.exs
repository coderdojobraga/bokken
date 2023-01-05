defmodule Bokken.Repo.Migrations.AddDiscordToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :discord_id, :string
    end
  end
end
