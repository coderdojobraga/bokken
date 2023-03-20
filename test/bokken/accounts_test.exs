defmodule Bokken.AccountsTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Accounts
  alias Faker.Avatar

  describe "guardians" do
    alias Bokken.Accounts.Guardian

    test "list_guardians/0 returns all guardians" do
      guardian = insert(:guardian)
      guardians = Accounts.list_guardians()

      assert hd(guardians).id == guardian.id
    end

    test "get_guardian!/1 returns the guardian with given id" do
      guardian = insert(:guardian)
      guardian_query = Accounts.get_guardian!(guardian.id)

      assert guardian_query.id == guardian.id
    end

    test "create_guardian/1 with valid data creates a guardian" do
      user = insert(:user)

      attrs =
        params_for(:guardian, user_id: user.id, user: user, city: "Braga", mobile: "+351915096743")

      assert {:ok, %Guardian{} = guardian} = Accounts.create_guardian(attrs)
      assert guardian.city == "Braga"
      assert guardian.mobile == "+351915096743"
    end

    test "create_guardian/1 with invalid data returns error changeset" do
      invalid_attrs = %{city: "Guimarães", mobile: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_guardian(invalid_attrs)
    end

    test "update_guardian/2 with valid data updates the guardian" do
      guardian = insert(:guardian)
      update_attrs = %{city: "Vizela", mobile: "+351934568701"}

      assert {:ok, %Guardian{} = guardian} = Accounts.update_guardian(guardian, update_attrs)
      assert guardian.city == "Vizela"
      assert guardian.mobile == "+351934568701"
    end

    test "update_guardian/2 with invalid data returns error changeset" do
      guardian = insert(:guardian)
      invalid_attrs = %{city: "Guimarães", mobile: nil}

      assert {:error, %Ecto.Changeset{} = _error} =
               Accounts.update_guardian(guardian, invalid_attrs)

      get_guardian = Accounts.get_guardian!(guardian.id)
      assert guardian.id == get_guardian.id
    end

    test "delete_guardian/1 deletes the guardian" do
      guardian = insert(:guardian)
      assert {:ok, %Guardian{}} = Accounts.delete_guardian(guardian)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_guardian!(guardian.id) end
    end

    test "change_guardian/1 returns a guardian changeset" do
      guardian = insert(:guardian)
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

    test "add an avatar to a mentor" do
      mentor = mentor_fixture()

      mentor2 =
        Accounts.update_mentor(mentor, %{
          photo: Avatar.image_url("./priv/faker/images/avatar.png")
        })

      photo = elem(mentor2, 1).photo
      assert photo != nil
    end

    test "add an avatar to a mentor with invalid file" do
      mentor = mentor_fixture()

      mentor2 =
        Accounts.update_mentor(mentor, %{
          photo: Avatar.image_url("./priv/faker/images/avatar.txt")
        })

      photo = nil

      if elem(mentor2, 0) == :ok do
        photo = elem(mentor2, 1).photo
      end

      assert photo == nil
    end
  end
end
