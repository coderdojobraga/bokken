defmodule Bokken.Repo.Migrations.CreateOrganizers do
  use Ecto.Migration

  def change do
    create table(:organizers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :champion, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:organizers, [:user_id])
    create index(:organizers, [:mentor_id])
  end
end
