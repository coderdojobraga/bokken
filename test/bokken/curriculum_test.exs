defmodule Bokken.CurriculumTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Curriculum

  import Bokken.Factory

  describe "skills" do
    alias Bokken.Curriculum.Skill

    test "create_skill/1 creates a skill when the data is valid" do
      skill_fixture = params_for(:skill)
      assert {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)
      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "create_skill/1 fails when the data is invalid" do
      skill_fixture = params_for(:skill, name: nil)
      assert {:error, _changeset} = Curriculum.create_skill(skill_fixture)
    end

    test "get_skill!/1 returns the skill" do
      skill = insert(:skill)

      assert %Skill{} = Curriculum.get_skill!(skill.id)
    end

    test "list_skills/0 returns all skills" do
      insert(:skill)

      assert [%Skill{}] = Curriculum.list_skills()
    end

    test "update_skill/1 updates a skill when the data is valid" do
      skill = insert(:skill)
      skill_fixture = params_for(:skill)

      assert {:ok, %Skill{} = skill} = Curriculum.update_skill(skill, skill_fixture)

      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "updates_skill/1 fails when the data is invalid" do
      skill = insert(:skill)

      skill_fixture = %{
        name: "Kotlin",
        description: nil
      }

      {:error, _changeset} = Curriculum.update_skill(skill, skill_fixture)
    end

    test "delete_skill/1 deletes existing skill" do
      skill = insert(:skill)
      assert {:ok, %Skill{}} = Curriculum.delete_skill(skill)
    end
  end

  describe "mentor_skills" do
    alias Bokken.Curriculum.{MentorSkill, Skill}

    setup [:create_mentor_data]

    test "create_mentor_skill/1 creates a mentor skill when the data is valid", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = params_for(:mentor_skill, skill_id: skill.id, mentor_id: mentor.id)

      assert {:ok, %MentorSkill{} = mentor_skill} =
               Curriculum.create_mentor_skill(mentor_skill_attrs)

      assert mentor_skill.mentor_id == mentor.id
      assert mentor_skill.skill_id == skill.id
    end

    test "create_mentor_skill/1 fails when the data is invalid", %{
      mentor: _mentor,
      skill: skill
    } do
      mentor_skill_attrs = params_for(:mentor_skill, skill_id: skill.id, mentor_id: nil)

      assert {:error, _changeset} = Curriculum.create_mentor_skill(mentor_skill_attrs)
    end

    test "list_mentor_skills/0 returns the requested mentor skills", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        "mentor_id" => mentor.id,
        "skill_id" => skill.id
      }

      assert {:ok, %MentorSkill{}} = Curriculum.create_mentor_skill(mentor_skill_attrs)
      assert [%Skill{}] = Curriculum.list_mentor_skills(%{"mentor_id" => mentor.id})

      assert [%Mentor{}] = Curriculum.list_mentors_with_skill(%{"skill_id" => skill.id})
    end

    test "mentor_has_skill?/1 returns correct value", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        "mentor_id" => mentor.id,
        "skill_id" => skill.id
      }

      insert(:mentor_skill, mentor: mentor, skill: skill)

      assert Curriculum.mentor_has_skill?(mentor_skill_attrs)
    end

    test "delete_mentor_skill/2 deletes a mentor skill", %{
      mentor: mentor,
      skill: skill
    } do
      insert(:mentor_skill, mentor: mentor, skill: skill)

      mentor_skill_attrs = %{
        "mentor_id" => mentor.id,
        "skill_id" => skill.id
      }

      assert {1, nil} = Curriculum.delete_mentor_skill(mentor_skill_attrs)
    end

    defp create_mentor_data(_x) do
      mentor_user = insert(:user, role: "mentor")

      mentor = insert(:mentor, user: mentor_user)

      skill = insert(:skill)

      %{
        mentor: mentor,
        skill: skill
      }
    end
  end

  describe "ninja_skills" do
    alias Bokken.Curriculum.{NinjaSkill, Skill}

    setup [:create_ninja_data]

    test "create_ninja_skill/1 creates a ninja skill when the data is valid", %{
      ninja: ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      assert {:ok, %NinjaSkill{} = ninja_skill} = Curriculum.create_ninja_skill(ninja_skill_attrs)
      assert ninja_skill.ninja_id == ninja.id
      assert ninja_skill.skill_id == skill.id
    end

    test "create_ninja_skill/1 fails when the data is invalid", %{
      ninja: _ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        ninja_id: nil,
        skill_id: skill.id
      }

      assert {:error, _changeset} = Curriculum.create_ninja_skill(ninja_skill_attrs)
    end

    test "list_ninja_skills/1 and list_ninjas_with_skill/1 return the requested ninja / skills",
         %{
           ninja: ninja,
           skill: skill
         } do
      insert(:ninja_skill, ninja: ninja, skill: skill)

      assert [%Skill{}] = Curriculum.list_ninja_skills(%{"ninja_id" => ninja.id})

      assert [%Ninja{}] = Curriculum.list_ninjas_with_skill(%{"skill_id" => skill.id})
    end

    test "ninja_has_skill?/1 returns the correct result", %{
      ninja: ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        "ninja_id" => ninja.id,
        "skill_id" => skill.id
      }

      insert(:ninja_skill, ninja: ninja, skill: skill)

      assert Curriculum.ninja_has_skill?(ninja_skill_attrs)
    end

    test "delete_ninja_skill/1 deletes a ninja skill", %{
      ninja: ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        "ninja_id" => ninja.id,
        "skill_id" => skill.id
      }

      {:ok, %NinjaSkill{}} = Curriculum.create_ninja_skill(ninja_skill_attrs)

      assert {1, nil} = Curriculum.delete_ninja_skill(ninja_skill_attrs)
    end

    defp create_ninja_data(_x) do
      ninja = insert(:ninja)

      skill = insert(:skill)

      %{
        ninja: ninja,
        skill: skill
      }
    end
  end
end
