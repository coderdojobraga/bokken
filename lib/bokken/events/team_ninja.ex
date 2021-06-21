defmodule Bokken.Events.TeamNinja do
  @moduledoc """
  Team and Ninja join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.Ninja
  alias Bokken.Events.Team

  @required_fields [:team_id, :ninja_id]
  @optional_fields []

  @primary_key false
  schema "teams_ninjas" do
    belongs_to :team, Team, type: :binary_id
    belongs_to :ninja, Ninja, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(team_ninja, attrs) do
    team_ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ninja)
    |> assoc_constraint(:team)
    |> unique_constraint([:ninja_id, :team_id], name: :teams_ninjas_pkey)
  end
end
