defmodule Bokken.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :document, :string
      add :description, :text
      add :ninja_id, references(:ninjas, on_delete: :delete_all, type: :binary_id)
      add :mentor_id, references(:mentors, on_delete: :delete_all, type: :binary_id)
      add :lecture_id, references(:lectures, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:files, [:mentor_id])
    create index(:files, [:ninja_id])
    create index(:files, [:lecture_id])
  end
end
