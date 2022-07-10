defmodule Bokken.GamificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bokken.Gamification` context.
  """

  @doc """
  Generate a badge.
  """
  def badge_fixture(attrs \\ %{}) do
    {:ok, badge} =
      attrs
      |> Enum.into(%{
        description: "Finished 5+ projects with success",
        name: "5 projects",
        image: %Plug.Upload{
          content_type: "image/png",
          filename: "badge.png",
          path: "./priv/faker/images/badge.png"
        }
      })
      |> Bokken.Gamification.create_badge()

    badge
  end
end
