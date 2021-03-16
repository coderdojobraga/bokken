defmodule Bokken.Accounts.Social do
  @moduledoc """
  A social media embedded struct schema.
  """
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field :name, Ecto.Enum, values: [:scratch, :codewars, :github, :gitlab]
    field :username, :string
  end
end
