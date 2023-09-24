defmodule Bokken.SkillJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Uploaders.Document
  alias BokkenWeb.SkillJSON

  test "data" do
    skill = build(:skill)
    rendered_skill = SkillJSON.data(%{skill: skill})

    assert rendered_skill == %{
             id: skill.id,
             name: skill.name,
             description: skill.description
           }
  end

  test "show" do
    skill = build(:skill)
    rendered_skill = SkillJSON.show(%{skill: skill})

    assert rendered_skill == %{
             data: SkillJSON.data(%{skill: skill})
           }
  end

  test "index" do
    skills = build_list(5, :skill)
    rendered_skills = SkillJSON.index(%{skills: skills})

    expected_data = Enum.map(skills, &SkillJSON.data(%{skill: &1}))

    assert rendered_skills == %{
             data: expected_data
           }
  end
end
