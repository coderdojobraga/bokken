defmodule Bokken.Curriculum.MentorSkill do
  @moduledoc """
  Mentor and Skill join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.Mentor
  alias Bokken.Curriculum.Skill

  @required_fields [:skill_id, :mentor_id]

  schema "mentors_skills" do
    belongs_to :skill, Skill
    belongs_to :mentor, Mentor

    timestamps()
  end

  @doc false
  def changeset(team_mentor, attrs) do
    team_mentor
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:mentor)
    |> assoc_constraint(:skill)
    |> unique_constraint([:mentor_id, :skill_id], name: :user_skills_mentor_pkey)
  end
end
