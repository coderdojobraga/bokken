defmodule Bokken.Gamification.BadgeNinja do
  @moduledoc """
  Badge and Ninja join table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.Ninja
  alias Bokken.Gamification.Badge

  @required_fields [:badge_id, :ninja_id]
  @optional_fields []

  @primary_key false
  schema "badges_ninjas" do
    belongs_to :badge, Badge
    belongs_to :ninja, Ninja, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(badge_ninja, attrs) do
    badge_ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:badge)
    |> assoc_constraint(:ninja)
    |> unique_constraint([:badge_id, :ninja_id], name: :badges_ninjas_pkey)
  end
end
