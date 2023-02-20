defmodule Bokken.Repo.Migrations.AddCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :ninja_id, references(:ninjas, on_delete: :nothing, type: :binary_id), null: true
      add :mentor_id, references(:mentors, on_delete: :nothing, type: :binary_id), null: true
      add :guardian_id, references(:guardians, on_delete: :nothing, type: :binary_id), null: true

      add :organizer_id, references(:organizers, on_delete: :nothing, type: :binary_id),
        null: true

      timestamps()
    end

    create unique_index(:credentials, [:ninja_id])
    create unique_index(:credentials, [:mentor_id])
    create unique_index(:credentials, [:guardian_id])
    create unique_index(:credentials, [:organizer_id])

    create constraint(:credentials, :unique_role, check: "
(
    ( CASE WHEN ninja_id IS NULL THEN 0 ELSE 1 END
    + CASE WHEN mentor_id IS NULL THEN 0 ELSE 1 END
    + CASE WHEN guardian_id IS NULL THEN 0 ELSE 1 END
    + CASE WHEN organizer_id IS NULL THEN 0 ELSE 1 END
    ) <= 1
)")
  end
end
