defmodule Bokken.Gamification.BadgesNinjas do
  @moduledoc """
  Badge and Ninja join table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.Ninja
  alias Bokken.Gamification.Badge

  @required_fields [:ninja_id, :badge_id]

  schema "badges_ninjas" do
    belongs_to :badge_id, Badge, type: :id, primary_key: true
    belongs_to :ninja_id, Ninja, type: :binary_id, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(badge_ninja, attrs) do
    badge_ninja
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:badge, :ninja])
  end
end
