defmodule Bokken.Classes.TeamMentor do
  @moduledoc """
  Team and Mentor join table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.Mentor
  alias Bokken.Classes.Team

  @required_fields [:team_id, :mentor_id]
  @optional_fields []

  @primary_key false
  @foreign_key_type :binary_id
  schema "teams_mentors" do
    belongs_to :team_id, Team, type: :binary_id
    belongs_to :mentor_id, Mentor, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(team_mentor, attrs) do
    team_mentor
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:team)
    |> assoc_constraint(:mentor)
    |> unique_constraint([:team_id, :mentor_id])
  end
end
