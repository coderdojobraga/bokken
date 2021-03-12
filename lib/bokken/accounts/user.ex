defmodule Bokken.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:first_name, :last_name, :email, :password, :role]
  @optional_fields [:photo, :active, :verified]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :photo, :string
    field :first_name, :string
    field :last_name, :string

    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    field :active, :boolean, default: false
    field :verified, :boolean, default: false
    field :role, Ecto.Enum, values: [:ninja, :guardian, :mentor, :organizer]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email, downcase: true)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 8)
  end
end
