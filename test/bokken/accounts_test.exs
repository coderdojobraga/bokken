defmodule Bokken.AccountsTest do
  @moduledoc false
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Accounts
  alias Faker.Avatar
  describe "guardians" do
    alias Bokken.Accounts.Guardian

    @update_attrs %{city: "Vizela", mobile: "+351934568701"}
    @invalid_attrs %{city: "Guimarães", mobile: nil}

    def valid_attr_guardian do
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

    def attrs_guardians do
      valid_attrs = valid_attr_guardian()
      user = valid_user()
      new_user = Accounts.create_user(user)
      user_id = elem(new_user, 1).id
      Map.put(valid_attrs, :user_id, user_id)
    end

    def guardian_fixture(atributes \\ %{}) do
      valid_attrs = attrs_guardians()

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
      attrs = attrs_guardians()
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

  describe "ninjas" do
    test "create_ninja/1 with invalid birthdate" do
      future_date = Date.utc_today() |> Date.add(1)
      guardian = insert(:guardian)

      attrs = %{
        first_name: "Ana Maria",
        last_name: "Silva Costa",
        birthday: future_date,
        guardian_id: guardian.id
      }

      assert {:error, %Ecto.Changeset{}} = Accounts.create_ninja(attrs)
    end
  end

  describe "mentors" do
    alias Bokken.Accounts.Mentor

    @update_attrs %{mobile: "+351934568701"}
    @invalid_attrs %{mobile: nil}

    def valid_attr_mentor do
      %{
        mobile: "+351915096743",
        first_name: "Jéssica",
        last_name: "Macedo Fernandes"
      }
    end

    def valid_user_mentor do
      %{
        email: "jessica_fernandes@gmail.com",
        password: "mentor123",
        role: "mentor"
      }
    end

    def attrs_mentors do
      valid_attrs = valid_attr_mentor()
      user = valid_user_mentor()
      new_user = Accounts.create_user(user)
      user_id = elem(new_user, 1).id
      Map.put(valid_attrs, :user_id, user_id)
    end

    def mentor_fixture(atributes \\ %{}) do
      valid_attrs = attrs_mentors()

      {:ok, mentor} =
        atributes
        |> Enum.into(valid_attrs)
        |> Accounts.create_mentor()

      mentor
    end

    test "list_mentors/0 returns all mentors" do
      mentor = mentor_fixture()
      assert Accounts.list_mentors() == [mentor]
    end

    test "get_mentor!/1 returns the mentor with given id" do
      mentor = mentor_fixture()
      assert Accounts.get_mentor!(mentor.id) == mentor
    end

    test "create_mentor/1 with valid data creates a mentor" do
      attrs = attrs_mentors()
      assert {:ok, %Mentor{} = mentor} = Accounts.create_mentor(attrs)
      assert mentor.mobile == "+351915096743"
    end

    test "create_mentor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_mentor(@invalid_attrs)
    end

    test "update_mentor/2 with valid data updates the mentor" do
      mentor = mentor_fixture()
      assert {:ok, %Mentor{} = mentor} = Accounts.update_mentor(mentor, @update_attrs)
      assert mentor.mobile == "+351934568701"
    end

    test "update_mentor/2 with invalid data returns error changeset" do
      mentor = mentor_fixture()

      assert {:error, %Ecto.Changeset{} = _error} =
               Accounts.update_mentor(mentor, @invalid_attrs)

      assert mentor == Accounts.get_mentor!(mentor.id)
    end

    test "delete_mentor/1 deletes the mentor" do
      mentor = mentor_fixture()
      assert {:ok, %Mentor{}} = Accounts.delete_mentor(mentor)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_mentor!(mentor.id) end
    end

    test "change_mentor/1 returns a mentor changeset" do
      mentor = mentor_fixture()
      assert %Ecto.Changeset{} = Accounts.change_mentor(mentor)
    end

    test "add an avatar to a mentor" do
      mentor = mentor_fixture()
      mentor2 = Accounts.update_mentor(mentor, %{photo: Avatar.image_url("./priv/faker/images/avatar.png")})
      photo = elem(mentor2, 1).photo
      assert photo != nil
    end

    test "add an avatar to a mentor with invalid file" do
      mentor = mentor_fixture()
      mentor2 = Accounts.update_mentor(mentor, %{photo: Avatar.image_url("./priv/faker/images/avatar.txt")})
      photo = nil
      if elem(mentor2, 0) == :ok do
        photo = elem(mentor2, 1).photo
      end
      assert photo == nil
    end
  end
end
