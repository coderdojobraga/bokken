defmodule Bokken.GamificationTest do
  use Bokken.DataCase, async: false

  alias Bokken.Gamification

  describe "badges" do
    alias Bokken.Gamification.Badge

    import Bokken.GamificationFixtures

    @invalid_attrs %{description: nil, image: nil, name: nil}

    test "list_badges/0 returns all badges" do
      badge = badge_fixture()
      assert Gamification.list_badges() == [badge]
    end

    test "get_badge!/1 returns the badge with given id" do
      badge = badge_fixture()
      assert Gamification.get_badge!(badge.id) == badge
    end

    test "create_badge/1 with valid data creates a badge" do
      random_number = Enum.random(1..100)
      img_url = Faker.Avatar.image_url("#{random_number}.png")
      valid_attrs = %{description: "some description", image: img_url, name: "some name"}

      assert {:ok, %Badge{} = badge} = Gamification.create_badge(valid_attrs)
      assert badge.description == "some description"
      assert badge.name == "some name"
    end

    test "create_badge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_badge(@invalid_attrs)
    end

    test "update_badge/2 with valid data updates the badge" do
      badge = badge_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name"
      }

      assert {:ok, %Badge{} = badge} = Gamification.update_badge(badge, update_attrs)
      assert badge.description == "some updated description"
      assert badge.name == "some updated name"
    end

    test "update_badge/2 with invalid data returns error changeset" do
      badge = badge_fixture()
      assert {:error, %Ecto.Changeset{}} = Gamification.update_badge(badge, @invalid_attrs)
      assert badge == Gamification.get_badge!(badge.id)
    end

    test "delete_badge/1 deletes the badge" do
      badge = badge_fixture()
      assert {:ok, %Badge{}} = Gamification.delete_badge(badge)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_badge!(badge.id) end
    end

    test "change_badge/1 returns a badge changeset" do
      badge = badge_fixture()
      assert %Ecto.Changeset{} = Gamification.change_badge(badge)
    end
  end
end
