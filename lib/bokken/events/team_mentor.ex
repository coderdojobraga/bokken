defmodule Bokken.Events.TeamMentor do
  @moduledoc """
  Team and Mentor join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.Mentor
  alias Bokken.Events.Team

  @required_fields [:team_id, :mentor_id]
  @optional_fields []

  @primary_key false
  schema "teams_mentors" do
    belongs_to :team, Team, type: :binary_id
    belongs_to :mentor, Mentor, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(team_mentor, attrs) do
    team_mentor
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:team)
    |> assoc_constraint(:mentor)
    |> unique_constraint([:team_id, :mentor_id], name: :teams_mentors_pkey)
  end
end
