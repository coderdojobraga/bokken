defmodule Bokken.Accounts.Social do
  @moduledoc """
  A social media embedded struct schema.
  """
  use Bokken.Schema

  alias __MODULE__

  @required_fields [:name, :username]
  @optional_fields []

  @derive Jason.Encoder
  @primary_key {:name, Ecto.Enum,
                values: [
                  :scratch,
                  :codewars,
                  :github,
                  :gitlab,
                  :trello,
                  :discord,
                  :slack,
                  :codemonkey,
                  :lightbot
                ],
                autogenerate: false}
  @foreign_key_type Ecto.Enum
  embedded_schema do
    field :username, :string
  end

  @doc false
  def changeset(%Social{} = social, attrs) do
    social
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  @doc """
    Used to verify if the user is deleting all of his socials and prevent the update from crash
  """
  def is_socials_empty?(changeset) do
    if changeset.params["socials"] == "[]" do
      Map.update!(changeset, :params, &Map.put(&1, "socials", []))
    else
      changeset
    end
  end
end
