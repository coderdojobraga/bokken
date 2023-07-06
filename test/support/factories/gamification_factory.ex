defmodule Bokken.Factories.GamificationFactory do
  @moduledoc """
  A factory to generate gamification related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Accounts.Ninja
      alias Bokken.Gamification.{Badge, BadgeNinja}

      def badge_factory do
        %Badge{
          name: Faker.Commerce.product_name(),
          description: Faker.Lorem.sentence(),
          image: nil
        }
      end

      def badge_ninja_factory do
        %BadgeNinja{
          badge: build(:badge),
          ninja: build(:ninja)
        }
      end
    end
  end
end
