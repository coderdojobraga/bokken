defmodule Bokken.AccountsTest do
  @moduledoc false
  use Bokken.DataCase

  import Bokken.Factory

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

  describe "credentials" do
    test "create_credential/1 with valid data (ninja)" do
      ninja = insert(:ninja)
      {:ok, credential} = Accounts.create_credential(%{ninja_id: ninja.id})
      assert credential.ninja_id == ninja.id
      assert credential.mentor_id == nil
      assert credential.guardian_id == nil
      assert credential.organizer_id == nil
    end

    test "create_credential/1 with valid data (nothing)" do
      {:ok, credential} = Accounts.create_credential()
      assert credential.ninja_id == nil
      assert credential.mentor_id == nil
      assert credential.guardian_id == nil
      assert credential.organizer_id == nil
    end

    test "create_credential/1 with invalid data" do
      ninja = insert(:ninja)
      guardian = insert(:guardian)

      assert {:error, _reason} =
               Accounts.create_credential(%{ninja_id: ninja.id, guardian_id: guardian.id})
    end

    test "get_credential!/1 with valid data (credential exists)" do
      credential_0 = insert(:credential)
      credential_1 = Accounts.get_credential!(%{"credential_id" => credential_0.id})
      assert credential_0.ninja_id == credential_1.ninja_id
      assert credential_0.mentor_id == credential_1.mentor_id
      assert credential_0.guardian_id == credential_1.guardian_id
      assert credential_0.organizer_id == credential_1.organizer_id
      assert credential_0.id == credential_1.id
    end

    test "get_credential!/1 with invalid data (credential does not exist)" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_credential!(%{"credential_id" => Ecto.UUID.generate()})
      end
    end

    test "update_credential/2 with valid data (credential exists)" do
      credential = insert(:credential)
      ninja = insert(:ninja)

      {:ok, credential_1} =
        Accounts.update_credential(credential, %{
          ninja_id: ninja.id,
          mentor_id: nil,
          organizer_id: nil,
          guardian_id: nil
        })

      assert credential_1.ninja_id == ninja.id
      assert credential_1.mentor_id == nil
      assert credential_1.guardian_id == nil
      assert credential_1.organizer_id == nil
      assert credential.id == credential_1.id
    end

    test "update_credential/2 with invalid data (credential exists)" do
      credential = insert(:credential)
      ninja = insert(:ninja)
      mentor = insert(:mentor)

      assert {:error, _reason} =
               Accounts.update_credential(credential, %{
                 ninja_id: ninja.id,
                 mentor_id: mentor.id,
                 organizer_id: nil,
                 guardian_id: nil
               })
    end

    test "delete_credential/1 with valid data" do
      credential = insert(:credential)
      Accounts.delete_credential(credential)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_credential!(%{"credential_id" => credential.id})
      end
    end
  end
end
