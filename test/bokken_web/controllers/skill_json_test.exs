defmodule Bokken.SkillJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.SkillJSON

  test "data" do
    skill = insert(:skill)
    rendered_skill = SkillJSON.data(skill)

    assert rendered_skill == %{
             id: skill.id,
             name: skill.name,
             description: skill.description
           }
  end

  test "show" do
    skill = insert(:skill)
    rendered_skill = SkillJSON.show(%{skill: skill})

    assert rendered_skill == %{
             data: SkillJSON.data(skill)
           }
  end

  test "index" do
    skills = insert_list(5, :skill)
    rendered_skills = SkillJSON.index(%{skills: skills})

    expected_data = for(skill <- skills, do: SkillJSON.data(skill))

    assert rendered_skills == %{
             data: expected_data
           }
  end
end
