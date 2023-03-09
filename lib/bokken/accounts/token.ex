defmodule Bokken.Accounts.Token do
  @moduledoc """
  A Token for microservices authentication.
  """
  use Bokken.Schema

  @required_fields [:name, :role]
  @optional_fields [:description]
  @roles [:bot]

  schema "tokens" do
    field :name, :string
    field :description, :string
    field :role, Ecto.Enum, values: @roles, default: :bot

    field :api_key, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def key_changeset(token, attrs) do
    token
    |> cast(attrs, [:api_key])
    |> validate_required([:api_key])
  end
end
