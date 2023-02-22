defmodule Bokken.AccountsTest do
  @moduledoc false
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Accounts

  describe "guardians" do
    alias Bokken.Accounts.Guardian

    test "list_guardians/0 returns all guardians" do
      guardian = insert(:guardian)
      guardians = Accounts.list_guardians()

      gurdians_ids = Enum.map(guardians, fn guardian -> guardian.id end)

      assert Enum.member?(gurdians_ids, guardian.id)
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
end
