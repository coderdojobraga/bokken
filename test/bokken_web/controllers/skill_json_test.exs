defmodule Bokken.SkillJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.SkillJSON

  test "index" do
    skills = build_list(5, :skill)
    rendered_skills = SkillJSON.index(%{skills: skills})

    assert rendered_skills == %{data: for(skill <- skills, do: SkillJSON.data(skill))}
  end

  test "show" do
    skill = build(:skill)
    rendered_skill = SkillJSON.show(%{skill: skill})

    assert rendered_skill == %{data: SkillJSON.data(skill)}
  end

  test "data" do
    skill = build(:skill)
    rendered_skill = SkillJSON.data(skill)

    assert rendered_skill == %{
             id: skill.id,
             name: skill.name,
             description: skill.description
           }
  end
end
