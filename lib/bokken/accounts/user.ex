defmodule Bokken.Accounts.User do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:email, :password, :role]
  @optional_fields [:active, :verified]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    field :active, :boolean, default: false
    field :verified, :boolean, default: false
    field :role, Ecto.Enum, values: [:ninja, :guardian, :mentor, :organizer]

    has_one :guardian, Bokken.Accounts.Guardian, on_delete: :delete_all
    has_one :mentor, Bokken.Accounts.Mentor, on_delete: :delete_all
    has_one :ninja, Bokken.Accounts.Guardian, on_delete: :delete_all

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
    |> encrypt_password()
  end

  defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp encrypt_password(changeset) do
    changeset
  end
end
