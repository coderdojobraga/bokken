defmodule Bokken.Repo.Migrations.AddUniqueIndexToUsersEmail do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :first_name, :string, null: false
      modify :last_name, :string, null: false
      modify :email, :string, null: false
      modify :password_hash, :string, null: false
      modify :role, :string, null: false
    end

    create unique_index(:users, [:email])
  end
end
