defmodule Mix.Tasks.Db.Gen.Badges do
  @moduledoc """
  A task to populate the database with some badges.
  """
  use Mix.Task

  @spec run(any) :: list
  def run(_) do
    Mix.Task.run("app.start")

    # Some badges
    [
      "Master Loop",
      "Five Projects",
      "If Then Else",
      "Complete Project"
    ]
    |> create_badges()
  end

  defp create_badges(names) do
    for character <- names do
      random = :rand.uniform(100)

      photo = "https://robohash.org/#{random}"
      description = character

      badge = %{description: description, name: character, photo: photo}

      Bokken.Gamification.create_badge(badge)
    end
  end
end
