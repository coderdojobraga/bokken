defmodule Bokken.Factories.BotsFactory do
  @moduledoc """
  A factory to generate event related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Accounts.Bot
      alias Faker.{String, StarWars}

      def bot_factory do
        %Bot{
          api_key: String.base64(32) |> Argon2.hash_pwd_salt(),
          name: StarWars.character()
        }
      end
    end
  end
end
