defmodule Bokken.CurriculumTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Curriculum

  describe "skills" do
    alias Bokken.Curriculum.Skill

    @invalid_skill %{
      name: nil,
      description: ""
    }

    test "create_skill/1 creates a skill when the data is valid" do
      skill_fixture = params_for(:skill)
      assert {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)
      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "create_skill/1 fails when the data is invalid" do
      assert {:error, _changeset} = Curriculum.create_skill(@invalid_skill)
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
      old_skill = insert(:skill)

      skill_params = params_for(:skill)

      assert {:ok, %Skill{} = skill} = Curriculum.update_skill(old_skill, skill_params)

      assert skill.name == skill_params.name
      assert skill.description == skill_params.description
    end

    test "updates_skill/1 fails when the data is invalid" do
      skill = insert(:skill)

      {:error, _changeset} = Curriculum.update_skill(skill, @invalid_skill)
    end

    test "updates_skills/1 fails when the data is invalid" do
      skill = insert(:skill)
      {:error, _changeset} = Curriculum.update_skill(skill, @invalid_skill)
    end

    test "delete_skill/1 deletes the data when valid" do
      skill = insert(:skill)

      assert %Ecto.Changeset{} = Curriculum.change_skill(skill, params_for(:skill))
    end
  end

  describe "mentor_skills" do
    alias Bokken.Curriculum.{MentorSkill, Skill}

    test "create_mentor_skill/1 creates a mentor skill when the data is valid" do
      mentor_skill_attrs = params_with_assocs(:mentor_skill)

      assert {:ok, %MentorSkill{} = mentor_skill} =
               Curriculum.create_mentor_skill(mentor_skill_attrs)

      assert mentor_skill.mentor_id == mentor_skill_attrs.mentor_id
      assert mentor_skill.skill_id == mentor_skill_attrs.skill_id
    end

    test "create_mentor_skill/1 fails when the data is invalid" do
      mentor_skill_attrs = %{
        mentor_id: nil,
        skill_id: insert(:skill).id
      }

      assert {:error, _changeset} = Curriculum.create_mentor_skill(mentor_skill_attrs)
    end

    test "list_mentor_skills/0 returns the requested mentor skills" do
      mentor_skill = insert(:mentor_skill)

      assert [%Skill{}] = Curriculum.list_mentor_skills(%{"mentor_id" => mentor_skill.mentor_id})

      assert [%Mentor{}] =
               Curriculum.list_mentors_with_skill(%{"skill_id" => mentor_skill.skill_id})
    end

    test "mentor_has_skill?/1 returns correct value" do
      mentor_skill = insert(:mentor_skill)

      assert Curriculum.mentor_has_skill?(%{
               "mentor_id" => mentor_skill.mentor_id,
               "skill_id" => mentor_skill.skill_id
             })
    end

    test "delete_mentor_skill/2 deletes a mentor skill" do
      mentor_skill = insert(:mentor_skill)

      assert {1, nil} =
               Curriculum.delete_mentor_skill(%{
                 "mentor_id" => mentor_skill.mentor_id,
                 "skill_id" => mentor_skill.skill_id
               })
    end
  end

  describe "ninja_skills" do
    alias Bokken.Curriculum.{NinjaSkill, Skill}

    test "create_ninja_skill/1 creates a ninja skill when the data is valid" do
      ninja_skill_attrs = params_with_assocs(:ninja_skill)

      assert {:ok, %NinjaSkill{} = ninja_skill} = Curriculum.create_ninja_skill(ninja_skill_attrs)
      assert ninja_skill.ninja_id == ninja_skill_attrs.ninja_id
      assert ninja_skill.skill_id == ninja_skill_attrs.skill_id
    end

    test "create_ninja_skill/1 fails when the data is invalid" do
      ninja_skill_attrs = %{
        ninja_id: nil,
        skill_id: insert(:skill).id
      }

      assert {:error, _changeset} = Curriculum.create_ninja_skill(ninja_skill_attrs)
    end

    test "list_ninja_skills/1 and list_ninjas_with_skill/1 return the requested ninja / skills" do
      ninja_skill_attrs = params_with_assocs(:ninja_skill)

      assert {:ok, %NinjaSkill{}} = Curriculum.create_ninja_skill(ninja_skill_attrs)

      assert [%Skill{}] =
               Curriculum.list_ninja_skills(%{"ninja_id" => ninja_skill_attrs.ninja_id})

      assert [%Ninja{}] =
               Curriculum.list_ninjas_with_skill(%{"skill_id" => ninja_skill_attrs.skill_id})
    end

    test "ninja_has_skill?/1 returns the correct result" do
      ninja_skill = insert(:ninja_skill)

      assert Curriculum.ninja_has_skill?(%{
               "ninja_id" => ninja_skill.ninja_id,
               "skill_id" => ninja_skill.skill_id
             })
    end

    test "delete_ninja_skill/1 deletes a ninja skill" do
      ninja_skill = insert(:ninja_skill)

      assert {1, nil} =
               Curriculum.delete_ninja_skill(%{
                 "ninja_id" => ninja_skill.ninja_id,
                 "skill_id" => ninja_skill.skill_id
               })
    end
  end
end
