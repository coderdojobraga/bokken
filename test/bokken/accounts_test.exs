defmodule Bokken.AccountsTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts

  describe "guardians" do
    alias Bokken.Accounts.Guardian

    @update_attrs %{city: "Vizela", mobile: "+351934568701"}
    @invalid_attrs %{city: "Guimarães", mobile: nil}

    def valid_attr do
      %{
        city: "Braga",
        mobile: "+351915096743",
        first_name: "Ana Maria",
        last_name: "Silva Costa"
      }
    end

    def valid_user do
      %{
        email: "anacosta@gmail.com",
        password: "guardian123",
        role: "guardian"
      }
    end

    def attrs do
      valid_attrs = valid_attr()
      user = valid_user()
      new_user = Accounts.create_user(user)
      user_id = elem(new_user, 1).id
      Map.put(valid_attrs, :user_id, user_id)
    end

    def guardian_fixture(atributes \\ %{}) do
      valid_attrs = attrs()

      {:ok, guardian} =
        atributes
        |> Enum.into(valid_attrs)
        |> Accounts.create_guardian()

      guardian
    end

    test "list_guardians/0 returns all guardians" do
      guardian = guardian_fixture()
      assert Accounts.list_guardians() == [guardian]
    end

    test "get_guardian!/1 returns the guardian with given id" do
      guardian = guardian_fixture()
      assert Accounts.get_guardian!(guardian.id) == guardian
    end

    test "create_guardian/1 with valid data creates a guardian" do
      attrs = attrs()
      assert {:ok, %Guardian{} = guardian} = Accounts.create_guardian(attrs)
      assert guardian.city == "Braga"
      assert guardian.mobile == "+351915096743"
    end

    test "create_guardian/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_guardian(@invalid_attrs)
    end

    test "update_guardian/2 with valid data updates the guardian" do
      guardian = guardian_fixture()
      assert {:ok, %Guardian{} = guardian} = Accounts.update_guardian(guardian, @update_attrs)
      assert guardian.city == "Vizela"
      assert guardian.mobile == "+351934568701"
    end

    test "update_guardian/2 with invalid data returns error changeset" do
      guardian = guardian_fixture()

      assert {:error, %Ecto.Changeset{} = _error} =
               Accounts.update_guardian(guardian, @invalid_attrs)

      assert guardian == Accounts.get_guardian!(guardian.id)
    end

    test "delete_guardian/1 deletes the guardian" do
      guardian = guardian_fixture()
      assert {:ok, %Guardian{}} = Accounts.delete_guardian(guardian)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_guardian!(guardian.id) end
    end

    test "change_guardian/1 returns a guardian changeset" do
      guardian = guardian_fixture()
      assert %Ecto.Changeset{} = Accounts.change_guardian(guardian)
    end
  end

  describe "skills" do
    alias Bokken.Accounts.Skill

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
      assert {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)
      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "create_skill/1 fails when the data is invalid" do
      skill_fixture = invalid_skill()
      assert {:error, _changeset} = Accounts.create_skill(skill_fixture)
    end

    test "get_skill!/1 returns the skill" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)

      assert %Skill{} = Accounts.get_skill!(skill.id)
    end

    test "list_skills/0 returns all skills" do
      skill_fixture = valid_skill()
      {:ok, %Skill{}} = Accounts.create_skill(skill_fixture)

      assert [%Skill{}] = Accounts.list_skills()
    end

    test "update_skill/1 updates a skill when the data is valid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description:
          "Kotlin is a cross-platform, statically typed, general-purpose programming language with type inference"
      }

      assert {:ok, %Skill{} = skill} = Accounts.update_skill(skill, skill_fixture)

      assert skill.name == skill_fixture.name
      assert skill.description == skill_fixture.description
    end

    test "updates_skill/1 fails when the data is invalid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description: nil
      }

      {:error, _changeset} = Accounts.update_skill(skill, skill_fixture)
    end

    test "updates_skills/1 fails when the data is invalid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Kotlin",
        description: nil
      }

      {:error, _changeset} = Accounts.update_skill(skill, skill_fixture)
    end

    test "delete_skill/1 deletes the data when valid" do
      skill_fixture = valid_skill()
      {:ok, %Skill{} = skill} = Accounts.create_skill(skill_fixture)

      skill_fixture = %{
        name: "Haskell"
      }

      assert %Ecto.Changeset{} = Accounts.change_skill(skill, skill_fixture)
    end
  end

  describe "user_skills" do
    alias Bokken.Accounts.UserSkill

    setup [:create_data]

    test "create_user_skill/1 creates a user skill when the data is valid (ninja)", %{
      ninja: ninja,
      mentor: _mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)
      assert user_skill.ninja_id == ninja.id
      assert user_skill.skill_id == skill.id
      assert is_nil(user_skill.mentor_id)
    end

    test "create_user_skill/1 creates a user skill when the data is valid (mentor)", %{
      ninja: _ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)
      assert user_skill.mentor_id == mentor.id
      assert user_skill.skill_id == skill.id
      assert is_nil(user_skill.ninja_id)
    end

    test "create_user_skill/1 fails when the data is invalid (both mentor and ninja)", %{
      ninja: ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:error, _changeset} = Accounts.create_user_skill(user_skill_attrs)
    end

    test "create_user_skill/1 fails when the data is valid (no mentor or ninja)", %{
      ninja: _ninja,
      mentor: _mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        skill_id: skill.id
      }

      assert {:error, _changeset} = Accounts.create_user_skill(user_skill_attrs)
    end

    test "list_user_skill/1 returns the requested user skills (ninja)", %{
      ninja: ninja,
      mentor: _mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{}} = Accounts.create_user_skill(user_skill_attrs)
      assert [%UserSkill{}] = Accounts.list_user_skills(%{"ninja_id" => ninja.id})
      assert [%UserSkill{}] = Accounts.list_user_skills(%{"skill_id" => skill.id})
    end

    test "list_user_skill/1 returns the requested user skills (mentor)", %{
      ninja: _ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{}} = Accounts.create_user_skill(user_skill_attrs)
      assert [%UserSkill{}] = Accounts.list_user_skills(%{"mentor_id" => mentor.id})
      assert [%UserSkill{}] = Accounts.list_user_skills(%{"skill_id" => skill.id})
    end

    test "get_user_skill!/1 returns the requested user skill", %{
      ninja: _ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)
      assert %UserSkill{} = Accounts.get_user_skill!(user_skill.id)
    end

    test "update_user_skill/1 updates a user skill when the data is valid", %{
      ninja: ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)

      user_skill_attrs = %{
        mentor_id: mentor.id,
        ninja_id: nil,
        skill_id: skill.id
      }

      assert {:ok, %UserSkill{} = user_skill} =
               Accounts.update_user_skill(user_skill, user_skill_attrs)

      assert user_skill.mentor_id == mentor.id
      assert user_skill.skill_id == skill.id
      assert is_nil(user_skill.ninja_id)
    end

    test "update_user_skills/1 fails when the data is invalid", %{
      ninja: ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)

      user_skill_attrs = %{
        mentor_id: mentor.id,
        skill_id: skill.id
      }

      assert {:error, _changeset} = Accounts.update_user_skill(user_skill, user_skill_attrs)
    end

    test "delete_user_skill/1 deletes a user skill", %{
      ninja: ninja,
      mentor: _mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)

      assert {:ok, %UserSkill{}} = Accounts.delete_user_skill(user_skill)
    end

    test "change_user_skill/1 returns a changeset", %{
      ninja: ninja,
      mentor: mentor,
      skill: skill
    } do
      user_skill_attrs = %{
        ninja_id: ninja.id,
        skill_id: skill.id
      }

      {:ok, %UserSkill{} = user_skill} = Accounts.create_user_skill(user_skill_attrs)

      user_skill_attrs = %{
        mentor_id: mentor.id,
        ninja_id: nil,
        skill_id: skill.id
      }

      assert %Ecto.Changeset{} = Accounts.change_user_skill(user_skill, user_skill_attrs)
    end

    defp create_data(_x) do
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
      {:ok, mentor_user} = Accounts.create_user(mentor_user_attrs)
      {:ok, guardian_user} = Accounts.create_user(guardian_user_attrs)

      {:ok, guardian} =
        Accounts.create_guardian(Map.put(guardian_attrs, :user_id, guardian_user.id))

      ninja_attrs =
        ninja_attrs
        |> Map.put(:guardian_id, guardian.id)
        |> Map.put(:user_id, ninja_user.id)

      {:ok, ninja} = Accounts.create_ninja(ninja_attrs)
      {:ok, mentor} = Accounts.create_mentor(Map.put(mentor_attrs, :user_id, mentor_user.id))

      {:ok, skill} = Accounts.create_skill(skill_attrs)

      %{
        ninja: ninja,
        mentor: mentor,
        skill: skill
      }
    end
  end
end
