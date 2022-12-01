defmodule Bokken.Repo.Migrations.AlterMentors do
  use Ecto.Migration

  def change do
    alter table(:mentors, primary_key: false) do
      add :t_shirt, :string
    end
  end
end
