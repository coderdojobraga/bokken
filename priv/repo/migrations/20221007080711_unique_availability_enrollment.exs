defmodule Bokken.Repo.Migrations.UniqueAvailabilityEnrollment do
  use Ecto.Migration

  def change do
    create unique_index(:enrollments, [:ninja_id, :event_id])
    create unique_index(:availabilities, [:mentor_id, :event_id])
  end
end
