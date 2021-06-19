defmodule Bokken.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :document, :string
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :lecture_id, references(:lectures, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:files, [:user_id])
    create index(:files, [:lecture_id])
  end
end
