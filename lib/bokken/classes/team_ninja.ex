defmodule Bokken.Classes.TeamNinja do
  @moduledoc """
  Team and Ninja join table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.Ninja
  alias Bokken.Classes.Team

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
    |> assoc_constraint(:team)
    |> assoc_constraint(:ninja)
    |> unique_constraint([:team_id, :ninja_id], name: :teams_ninjas_pkey)
  end
end
