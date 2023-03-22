defmodule Bokken.Accounts.User do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Guardian, Mentor, Ninja, Organizer}
  alias Bokken.Documents.File

  @roles [:ninja, :guardian, :mentor, :organizer]

  @required_fields [:email, :password, :role]
  @optional_fields [:active, :verified, :registered, :total_file_size]

  # List of fields that can be updated by admins (organizers)
  @admin_fields [:active, :verified, :registered]

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    field :active, :boolean, default: false
    field :verified, :boolean, default: false
    field :registered, :boolean, default: false
    field :role, Ecto.Enum, values: @roles
    field :total_file_size, :integer, default: 0

    has_one :guardian, Guardian, on_delete: :delete_all
    has_one :mentor, Mentor, on_delete: :delete_all
    has_one :ninja, Ninja, on_delete: :delete_all
    has_one :organizer, Organizer, on_delete: :delete_all

    field :reset_password_token, :string
    field :reset_token_sent_at, :utc_datetime

    has_many :files, File, on_delete: :delete_all

    timestamps()
  end

  def register_ninja_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> change(%{
      active: true,
      registered: true,
      role: :ninja,
      password: Base.encode64(:crypto.strong_rand_bytes(32))
    })
    |> hash_password()
    |> check_if_email_changed()
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

  def admin_changeset(user, attrs) do
    user
    |> cast(attrs, @admin_fields)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> check_required(user.password_hash)
    |> user_validations()
  end

  def password_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:reset_password_token, :reset_token_sent_at])
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> hash_password()
  end

  defp user_validations(changeset) do
    changeset
    |> unique_constraint(:email, downcase: true)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 8)
    |> hash_password()
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

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  defp check_if_email_changed(
         %Ecto.Changeset{valid?: true, changes: %{email: _email}} = changeset
       ) do
    change(changeset, verified: false)
  end

  defp check_if_email_changed(changeset), do: changeset
end
