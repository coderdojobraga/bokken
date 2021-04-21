defmodule Bokken.AccountsTest do
  use Bokken.DataCase

  alias Bokken.Accounts

  describe "guardians" do
    alias Bokken.Accounts.Guardian

    @update_attrs %{city: "Vizela", mobile: "934568701"}
    @invalid_attrs %{city: "Guimarães", mobile: nil}

    def valid_attr do
      %{
        city: "Braga",
        mobile: "915096743",
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
      assert guardian.mobile == "915096743"
    end

    test "create_guardian/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_guardian(@invalid_attrs)
    end

    test "update_guardian/2 with valid data updates the guardian" do
      guardian = guardian_fixture()
      assert {:ok, %Guardian{} = guardian} = Accounts.update_guardian(guardian, @update_attrs)
      assert guardian.city == "Vizela"
      assert guardian.mobile == "934568701"
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

  describe "organizers" do
    alias Bokken.Accounts.Organizer

    @valid_attrs %{champion: true}
    @update_attrs %{champion: false}
    @invalid_attrs %{champion: nil}

    def organizer_fixture(attrs \\ %{}) do
      {:ok, organizer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_organizer()

      organizer
    end

    test "list_organizers/0 returns all organizers" do
      organizer = organizer_fixture()
      assert Accounts.list_organizers() == [organizer]
    end

    test "get_organizer!/1 returns the organizer with given id" do
      organizer = organizer_fixture()
      assert Accounts.get_organizer!(organizer.id) == organizer
    end

    test "create_organizer/1 with valid data creates a organizer" do
      assert {:ok, %Organizer{} = organizer} = Accounts.create_organizer(@valid_attrs)
      assert organizer.champion == true
    end

    test "create_organizer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organizer(@invalid_attrs)
    end

    test "update_organizer/2 with valid data updates the organizer" do
      organizer = organizer_fixture()
      assert {:ok, %Organizer{} = organizer} = Accounts.update_organizer(organizer, @update_attrs)
      assert organizer.champion == false
    end

    test "update_organizer/2 with invalid data returns error changeset" do
      organizer = organizer_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organizer(organizer, @invalid_attrs)
      assert organizer == Accounts.get_organizer!(organizer.id)
    end

    test "delete_organizer/1 deletes the organizer" do
      organizer = organizer_fixture()
      assert {:ok, %Organizer{}} = Accounts.delete_organizer(organizer)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organizer!(organizer.id) end
    end

    test "change_organizer/1 returns a organizer changeset" do
      organizer = organizer_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organizer(organizer)
    end
  end
end
