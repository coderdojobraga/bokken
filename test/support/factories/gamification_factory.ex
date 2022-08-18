defmodule Bokken.Factories.GamificationFactory do
  @moduledoc """
  A factory to generate gamification related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Factories.AccountFactory
      alias Faker.{Avatar, Company.En, Lorem}
      alias Bokken.Gamification.{Badge, BadgeNinja}

      def badge_factory do
        %Badge{
          name: En.name(),
          description: Lorem.sentence(),
          image: %Plug.Upload{
            content_type: "image/png",
            filename: "badge.png",
            path: "./priv/faker/images/badge.png"
          }
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
