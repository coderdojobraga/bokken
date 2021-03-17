defmodule Bokken.AccountsTest do
  use Bokken.DataCase

  alias Bokken.Accounts

  describe "ninjas" do
    alias Bokken.Accounts.Ninja

    @valid_attrs %{belt: "some belt", birthday: ~D[2010-04-17], notes: "some notes", social: []}
    @update_attrs %{
      belt: "some updated belt",
      birthday: ~D[2011-05-18],
      notes: "some updated notes",
      social: []
    }
    @invalid_attrs %{belt: nil, birthday: nil, notes: nil, social: nil}

    def ninja_fixture(attrs \\ %{}) do
      {:ok, ninja} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_ninja()

      ninja
    end

    test "list_ninjas/0 returns all ninjas" do
      ninja = ninja_fixture()
      assert Accounts.list_ninjas() == [ninja]
    end

    test "get_ninja!/1 returns the ninja with given id" do
      ninja = ninja_fixture()
      assert Accounts.get_ninja!(ninja.id) == ninja
    end

    test "create_ninja/1 with valid data creates a ninja" do
      assert {:ok, %Ninja{} = ninja} = Accounts.create_ninja(@valid_attrs)
      assert ninja.belt == "some belt"
      assert ninja.birthday == ~D[2010-04-17]
      assert ninja.notes == "some notes"
      assert ninja.social == []
    end

    test "create_ninja/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_ninja(@invalid_attrs)
    end

    test "update_ninja/2 with valid data updates the ninja" do
      ninja = ninja_fixture()
      assert {:ok, %Ninja{} = ninja} = Accounts.update_ninja(ninja, @update_attrs)
      assert ninja.belt == "some updated belt"
      assert ninja.birthday == ~D[2011-05-18]
      assert ninja.notes == "some updated notes"
      assert ninja.social == []
    end

    test "update_ninja/2 with invalid data returns error changeset" do
      ninja = ninja_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_ninja(ninja, @invalid_attrs)
      assert ninja == Accounts.get_ninja!(ninja.id)
    end

    test "delete_ninja/1 deletes the ninja" do
      ninja = ninja_fixture()
      assert {:ok, %Ninja{}} = Accounts.delete_ninja(ninja)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_ninja!(ninja.id) end
    end

    test "change_ninja/1 returns a ninja changeset" do
      ninja = ninja_fixture()
      assert %Ecto.Changeset{} = Accounts.change_ninja(ninja)
    end
  end
end
