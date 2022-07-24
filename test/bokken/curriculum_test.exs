defmodule Bokken.CurriculumTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Curriculum

  describe "skills" do
    alias Bokken.Curriculum.Skill

    def valid_skill do
      %{
        name: "Java",
        description:
          "Java is a high-level, class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible"
      }
    end

    def update_skill do
      %{
        description:
          "It is a general-purpose programming language intended to let programmers write once, run anywhere"
      }
    end

    def invalid_skill do
      %{
        name: "Haskell"
      }
    end

    test "create_skill/1 creates a skill when the data is valid" do
      skill_fixture = valid_skill()
      assert {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)
      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "create_skill/1 fails when the data is invalid" do
      skill_fixture = invalid_skill()
      assert {:error, _changeset} = Curriculum.create_skill(skill_fixture)
    end

    test "get_skill!/1 returns the skill" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)

      assert %Skill{} = Curriculum.get_skill!(skill.id)
    end

    test "list_skills/0 returns all skills" do
      skill_fixture = valid_skill()
      {:ok, %Skill{}} = Curriculum.create_skill(skill_fixture)

      assert [%Skill{}] = Curriculum.list_skills()
    end

    test "update_skill/1 updates a skill when the data is valid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description:
          "Kotlin is a cross-platform, statically typed, general-purpose programming language with type inference"
      }

      assert {:ok, %Skill{} = skill} = Curriculum.update_skill(skill, skill_fixture)

      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "updates_skill/1 fails when the data is invalid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description: nil
      }

      {:error, _changeset} = Curriculum.update_skill(skill, skill_fixture)
    end

    test "updates_skills/1 fails when the data is invalid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description: nil
      }

      {:error, _changeset} = Curriculum.update_skill(skill, skill_fixture)
    end

    test "delete_skill/1 deletes the data when valid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Curriculum.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Haskell"
      }

      assert %Ecto.Changeset{} = Curriculum.change_skill(skill, skill_fixture)
    end
  end

  describe "mentor_skills" do
    alias Bokken.Curriculum.{MentorSkill, Skill}

    setup [:create_mentor_data]

    test "create_mentor_skill/1 creates a mentor skill when the data is valid", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:ok, %MentorSkill{} = mentor_skill} =
               Curriculum.create_mentor_skill(mentor_skill_attrs)

      assert mentor_skill.mentor_id == mentor.id
      assert mentor_skill.skill_id == skill.id
    end

    test "create_mentor_skill/1 fails when the data is invalid", %{
      mentor: _mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        mentor_id: nil,
        skill_id: skill.id
      }

      assert {:error, _changeset} = Curriculum.create_mentor_skill(mentor_skill_attrs)
    end

    test "list_mentor_skills/0 returns the requested mentor skills", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
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
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:ok, %MentorSkill{}} = Curriculum.create_mentor_skill(mentor_skill_attrs)

      assert Curriculum.mentor_has_skill?(mentor_skill_attrs)
    end

    test "delete_mentor_skill/2 deletes a mentor skill", %{
      mentor: mentor,
      skill: skill
    } do
      mentor_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      {:ok, %MentorSkill{}} = Curriculum.create_mentor_skill(mentor_skill_attrs)

      assert {1, nil} = Curriculum.delete_mentor_skill(mentor_skill_attrs)
    end

    defp create_mentor_data(_x) do
      mentor_user_attrs = %{
        email: "mentor1@gmail.com",
        password: "mentor123",
        role: "mentor"
      }

      mentor_attrs = %{
        first_name: "Rui",
        last_name: "Lopes",
        mobile: "912345678"
      }

      skill_attrs = valid_skill()

      {:ok, mentor_user} = Accounts.create_user(mentor_user_attrs)

      {:ok, mentor} = Accounts.create_mentor(Map.put(mentor_attrs, :user_id, mentor_user.id))

      {:ok, skill} = Curriculum.create_skill(skill_attrs)

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
      ninja_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      assert {:ok, %NinjaSkill{}} = Curriculum.create_ninja_skill(ninja_skill_attrs)
      assert [%Skill{}] = Curriculum.list_ninja_skills(%{"ninja_id" => ninja.id})
      assert [%Ninja{}] = Curriculum.list_ninjas_with_skill(%{"skill_id" => skill.id})
    end

    test "ninja_has_skill?/1 returns the correct result", %{
      ninja: ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      assert {:ok, %NinjaSkill{}} = Curriculum.create_ninja_skill(ninja_skill_attrs)
      assert Curriculum.ninja_has_skill?(ninja_skill_attrs)
    end

    test "delete_ninja_skill/1 deletes a ninja skill", %{
      ninja: ninja,
      skill: skill
    } do
      ninja_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      {:ok, %NinjaSkill{}} = Curriculum.create_ninja_skill(ninja_skill_attrs)

      assert {1, nil} = Curriculum.delete_ninja_skill(ninja_skill_attrs)
    end

    defp create_ninja_data(_x) do
      ninja_user_attrs = %{
        email: "ninja1@gmail.com",
        password: "ninja123",
        role: "ninja"
      }

      ninja_attrs = %{
        first_name: "Maria",
        last_name: "Silva",
        birthday: ~U[2007-03-14 00:00:00.000Z]
      }

      guardian_user_attrs = %{
        email: "guardian1@gmail.com",
        password: "guardian123",
        role: "guardian"
      }

      guardian_attrs = %{
        first_name: "João",
        last_name: "Silva",
        mobile: "912345678"
      }

      skill_attrs = valid_skill()

      {:ok, ninja_user} = Accounts.create_user(ninja_user_attrs)
      {:ok, guardian_user} = Accounts.create_user(guardian_user_attrs)

      {:ok, guardian} =
        Accounts.create_guardian(Map.put(guardian_attrs, :user_id, guardian_user.id))

      ninja_attrs =
        ninja_attrs
        |> Map.put(:guardian_id, guardian.id)
        |> Map.put(:user_id, ninja_user.id)

      {:ok, ninja} = Accounts.create_ninja(ninja_attrs)

      {:ok, skill} = Curriculum.create_skill(skill_attrs)

      %{
        ninja: ninja,
        skill: skill
      }
    end
  end
end
