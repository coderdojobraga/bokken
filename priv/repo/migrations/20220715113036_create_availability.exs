defmodule Bokken.Repo.Migrations.CreateAvailability do
  use Ecto.Migration

  def change do
    create table(:availabilities, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :is_available, :boolean
      add :mentor_id, references(:mentors, on_delete: :delete_all, type: :binary_id)
      add :event_id, references(:events, on_delete: :delete_all, type: :binary_id)

      add :notes, :string

      timestamps()
    end

    create index(:availabilities, [:mentor_id])
    create index(:availabilities, [:event_id])
  end
end
