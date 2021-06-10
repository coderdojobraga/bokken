defmodule Bokken.Accounts.Social do
  @moduledoc """
  A social media embedded struct schema.
  """
  use Bokken.Schema

  alias __MODULE__

  @required_fields [:name, :username]
  @optional_fields []

  @derive Jason.Encoder
  embedded_schema do
    field :name, Ecto.Enum, values: [:scratch, :codewars, :github, :gitlab]
    field :username, :string
  end

  @doc false
  def changeset(%Social{} = social, attrs) do
    social
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
