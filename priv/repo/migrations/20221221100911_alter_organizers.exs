defmodule Bokken.Repo.Migrations.AlterOrganizers do
  use Ecto.Migration

  def change do
    alter table(:organizers, primary_key: false) do
      add :first_name, :string, default: "", null: false
      add :last_name, :string, default: "", null: false
    end
  end
end
