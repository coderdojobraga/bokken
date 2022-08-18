defmodule Bokken.GamificationTest do
  use Bokken.DataCase

  alias Bokken.Gamification

  describe "badges" do
    alias Bokken.Gamification.Badge

    @invalid_attrs %{description: nil, image: nil, name: nil}

    test "list_badges/0 returns all badges" do
      badge = FileUploadStrategy.insert_with_file_upload(%Badge{})
      assert Gamification.list_badges() == [badge]
    end

    test "get_badge!/1 returns the badge with given id" do
      badge = FileUploadStrategy.insert_with_file_upload(%Badge{})
      assert Gamification.get_badge!(badge.id) == badge
    end

    test "create_badge/1 with valid data creates a badge" do
      valid_attrs = params_for(:badge)

      assert {:ok, %Badge{} = badge} = Gamification.create_badge(valid_attrs)
      assert badge.description == valid_attrs[:description]
      assert badge.name == valid_attrs[:name]
    end

    test "create_badge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_badge(@invalid_attrs)
    end

    test "update_badge/2 with valid data updates the badge" do
      badge = FileUploadStrategy.insert_with_file_upload(%Badge{})

      update_attrs = params_for(:badge)

      assert {:ok, %Badge{} = badge} = Gamification.update_badge(badge, update_attrs)
      assert badge.description == update_attrs[:description]
      assert badge.name == update_attrs[:name]
    end

    test "update_badge/2 with invalid data returns error changeset" do
      badge = FileUploadStrategy.insert_with_file_upload(%Badge{})
      assert {:error, %Ecto.Changeset{}} = Gamification.update_badge(badge, @invalid_attrs)
      assert badge == Gamification.get_badge!(badge.id)
    end

    test "delete_badge/1 deletes the badge" do
      badge = FileUploadStrategy.insert_with_file_upload(%Badge{})
      assert {:ok, %Badge{}} = Gamification.delete_badge(badge)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_badge!(badge.id) end
    end

    test "change_badge/1 returns a badge changeset" do
      badge = insert_with_file_upload(:badge)
      assert %Ecto.Changeset{} = Gamification.change_badge(badge)
    end
  end
end
