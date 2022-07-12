defmodule Bokken.Accounts.UserSkill do
  @moduledoc """
  User (ninja / mentor) and skill join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Mentor, Ninja, Skill}

  @required_fields [:skill_id]
  @optional_fields [:mentor_id, :ninja_id]

  schema "user_skills" do
    belongs_to :skill, Skill, type: :binary_id
    belongs_to :mentor, Mentor, type: :binary_id
    belongs_to :ninja, Ninja, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(team_ninja, attrs) do
    team_ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:mentor)
    |> assoc_constraint(:ninja)
    |> assoc_constraint(:skill)
    |> unique_constraint([:ninja_id, :skill_id], name: :user_skills_ninja_pkey)
    |> unique_constraint([:mentor_id, :skill_id], name: :user_skills_mentor_pkey)
    |> check_constraint(
      :user_skills,
      name: :mentor_or_ninja,
      message: "Either mentor or ninja can't be blank"
    )
  end
end
