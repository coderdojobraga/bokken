defmodule Bokken.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :spots_available, :integer, null: false
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :enrollments_open, :utc_datetime
      add :enrollments_close, :utc_datetime
      add :online, :boolean, null: false, default: false
      add :notes, :text

      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:events, [:location_id])
    create index(:events, [:team_id])
  end
end
