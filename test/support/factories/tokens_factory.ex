defmodule Bokken.Factories.TokenFactory do
  @moduledoc """
  A factory to generate event related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Accounts.Token
      alias Faker.{Lorem, StarWars, String}

      def token_factory do
        %Token{
          name: StarWars.character(),
          description: Lorem.sentence(),
          role: "bot"
        }
      end
    end
  end
end
