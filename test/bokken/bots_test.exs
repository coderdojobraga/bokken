defmodule Bokken.BotsTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Bot

  import Bokken.Factory

  describe "Bots" do
    test "list_bots/0 returns all bots" do
      bot = insert(:bot)

      assert Accounts.list_bots() == [bot]
    end

    test "create_bot/1 creates a new bot" do
      attrs = %{
        name: Faker.Pokemon.name(),
        api_key: Faker.String.base64(32)
      }

      assert {:ok, %Bot{}} = Accounts.create_bot(attrs)
    end

    test "update_bot/2 updates an existing bot" do
      bot = insert(:bot)
      name = Faker.Pokemon.name()

      assert {:ok, %Bot{} = updated_bot} = Accounts.update_bot(bot, %{name: name})
      assert updated_bot.name == name
    end

    test "get_bot!/1 gives back a bot with the given id" do
      bot = insert(:bot)

      assert bot == Accounts.get_bot!(bot.id)
    end

    test "delete_bot/1 deletes a bot with the given id" do
      bot = insert(:bot)

      assert {:ok, %Bot{}} = Accounts.delete_bot(bot)
    end
  end
end
