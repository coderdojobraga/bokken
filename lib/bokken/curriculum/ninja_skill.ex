defmodule Bokken.Curriculum.NinjaSkill do
  @moduledoc """
  Ninja and Skill join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.Ninja
  alias Bokken.Curriculum.Skill

  @required_fields [:skill_id, :ninja_id]

  schema "ninjas_skills" do
    belongs_to :skill, Skill
    belongs_to :ninja, Ninja

    timestamps()
  end

  @doc false
  def changeset(team_ninja, attrs) do
    team_ninja
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ninja)
    |> assoc_constraint(:skill)
    |> unique_constraint([:ninja_id, :skill_id], name: :user_skills_ninja_pkey)
  end
end
