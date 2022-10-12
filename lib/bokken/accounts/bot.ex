defmodule Bokken.Accounts.Bot do
  @moduledoc """
  A bot of a third party application capable of viewing and changing data.
  """
  use Bokken.Schema

  @required_fields [:name, :api_key]

  schema "bots" do
    field :name, :string
    field :api_key, :string 
  end

  @doc false
  def changeset(bot, attrs) do
    bot 
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
