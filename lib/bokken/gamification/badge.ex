defmodule Bokken.Gamification.Badge do
  @moduledoc """
  Badges are awards earned by ninjas for conquering challenges and finishing
  projects.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.Ninja
  alias Bokken.Gamification.BadgeNinja

  @required_fields [:name, :image]
  @optional_fields [:description]

  schema "badges" do
    field :name, :string
    field :description, :string
    field :image, :string

    many_to_many :ninjas, Ninja, join_through: BadgeNinja

    timestamps()
  end

  @doc false
  def changeset(badge, attrs) do
    badge
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
