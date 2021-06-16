defmodule Bokken.Accounts.User do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Guardian, Mentor, Ninja, Organizer}

  @required_fields [:email, :password, :role]
  @optional_fields [:active, :verified, :registered]

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    field :active, :boolean, default: false
    field :verified, :boolean, default: false
    field :registered, :boolean, default: false
    field :role, Ecto.Enum, values: [:ninja, :guardian, :mentor, :organizer]

    has_one :guardian, Guardian, on_delete: :delete_all
    has_one :mentor, Mentor, on_delete: :delete_all
    has_one :ninja, Ninja, on_delete: :delete_all
    has_one :organizer, Organizer, on_delete: :delete_all

    timestamps()
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> check_required(user.password_hash)
    |> user_validations()
  end

  def edit_changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> check_required(user.password_hash)
    |> user_validations()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> check_required(user.password_hash)
    |> user_validations()
  end

  defp user_validations(changeset) do
    changeset
    |> unique_constraint(:email, downcase: true)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 8)
    |> encrypt_password()
    |> check_if_email_changed()
  end

  defp check_required(%Ecto.Changeset{} = changeset, hash) do
    case hash do
      nil ->
        changeset
        |> validate_required(@required_fields)

      _ ->
        changeset
        |> validate_required(@required_fields -- [:password])
    end
  end

  defp encrypt_password(%Ecto.Changeset{} = changeset) do
    case changeset do
      %{valid?: true, changes: %{password: password}} ->
        change(changeset, password_hash: Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp check_if_email_changed(changeset) do
    case changeset do
      %{valid?: true, changes: %{email: _email}} ->
        change(changeset, verified: false)

      _ ->
        changeset
    end
  end
end
