defmodule Bokken.TokensTest do
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Token

  import Bokken.Factory

  describe "Tokens" do
    test "list_tokens/0 returns all tokens" do
      token = insert(:token)

      assert Accounts.list_tokens() == [token]
    end

    test "create_token/1 creates a new token" do
      attrs = %{
        name: Faker.Pokemon.name(),
        role: "bot"
      }

      assert {:ok, %Token{}} = Accounts.create_token(attrs)
    end

    test "update_token/2 updates an existing token" do
      token = insert(:token)
      name = Faker.Pokemon.name()

      assert {:ok, %Token{} = updated_token} = Accounts.update_token(token, %{name: name})
      assert updated_token.name == name
    end

    test "get_token!/1 gives back a token with the given id" do
      token = insert(:token)

      assert token == Accounts.get_token!(token.id)
    end

    test "delete_token/1 deletes a token with the given id" do
      token = insert(:token)

      assert {:ok, %Token{}} = Accounts.delete_token(token)
    end
  end
end
