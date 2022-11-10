defmodule Bokken.Accounts.Bot do
  @moduledoc """
  A bot of a third party application capable of viewing and changing data.
  """
  use Bokken.Schema

  @required_fields [:name, :api_key]

  schema "bots" do
    field :name, :string
    field :api_key, :string

    timestamps()
  end

  @doc false
  def changeset(bot, attrs) do
    bot
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> encrypt_password()
  end

  defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{api_key: api_key}} = changeset) do
    change(changeset, api_key: Argon2.hash_pwd_salt(api_key))
  end

  defp encrypt_password(changeset), do: changeset
end
