defmodule Bokken.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users, primary_key: false) do
      add :total_file_size, :integer, default: 0
    end
  end
end
