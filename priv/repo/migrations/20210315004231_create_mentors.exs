defmodule Bokken.Repo.Migrations.CreateMentors do
  use Ecto.Migration

  def change do
    create table(:mentors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :mobile, :string, null: false
      add :birthday, :date
      add :major, :string
      add :trial, :boolean, default: true, null: false
      add :socials, {:array, :map}, default: []
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:mentors, [:user_id])
  end
end
