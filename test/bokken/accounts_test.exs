defmodule Bokken.AccountsTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts

  describe "guardians" do
    alias Bokken.Accounts.Guardian

    test "list_guardians/0 returns all guardians" do
      guardian = insert_with_file_upload(:guardian)

      assert Accounts.list_guardians()
             |> Repo.preload(:user) == [guardian]
    end

    test "get_guardian!/1 returns the guardian with given id" do
      guardian = insert_with_file_upload(:guardian)
      assert Accounts.get_guardian!(guardian.id, [:user]) == guardian
    end

    test "create_guardian/1 with valid data creates a guardian" do
      attrs = params_with_assocs(:guardian)
      assert {:ok, %Guardian{} = guardian} = Accounts.create_guardian(attrs)
      assert guardian.user_id == attrs.user_id
    end

    test "create_guardian/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_guardian(params_for(:guardian, mobile: nil))
    end

    test "update_guardian/2 with valid data updates the guardian" do
      guardian = insert_with_file_upload(:guardian)
      new_attrs = params_for(:guardian)

      assert {:ok, %Guardian{} = guardian} = Accounts.update_guardian(guardian, new_attrs)

      assert guardian.city == new_attrs[:city]
      assert guardian.mobile == new_attrs[:mobile]
    end

    test "update_guardian/2 with invalid data returns error changeset" do
      guardian = insert_with_file_upload(:guardian)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_guardian(guardian, params_for(:guardian, city: "invalid"))

      assert guardian == Accounts.get_guardian!(guardian.id, [:user])
    end

    test "delete_guardian/1 deletes the guardian" do
      guardian = insert_with_file_upload(:guardian)
      assert {:ok, %Guardian{}} = Accounts.delete_guardian(guardian)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_guardian!(guardian.id) end
    end

    test "change_guardian/1 returns a guardian changeset" do
      guardian = build(:guardian)
      assert %Ecto.Changeset{} = Accounts.change_guardian(guardian)
    end
  end
end
