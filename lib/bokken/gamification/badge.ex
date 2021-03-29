defmodule Bokken.Gamification.Badge do
  @moduledoc """
  A badge is a virtual medal that a ninja can won after conquer some challenges
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :photo]
  @optional_fields [:description]

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :id

  schema "badges" do
    field :description, :string
    field :name, :string
    field :photo, :string

    timestamps()

    many_to_many :ninjas, Bokken.Accounts.Ninja, join_through: "bagdes_ninjas"
  end

  @doc false
  def changeset(badge, attrs) do
    badge
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
