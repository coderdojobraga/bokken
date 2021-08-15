defmodule Bokken.Repo.Seeds.Gamification do
  def run do
    case Bokken.Repo.all(Bokken.Gamification.Badge) do
      [] ->
        [
          "My First Project",
          "Finished 5 Projects",
          "Finished 10 Projects",
          "Finished 20 Projects",
          "Finished 50 Projects",
          "Finished 100 Projects",
          "Conditions Master",
          "Functions Master",
          "Modules Master",
          "Algorithms Master",
          "Loop Master",
          "Scratch",
          "Ruby",
          "Python",
          "Haskell",
          "Elixir",
          "JavaScript"
        ]
        |> create_badges()
      _ ->
        Mix.shell().error("Found badges, aborting seeding badges.")
    end

  end

  def create_badges(titles) do
    for title <- titles do
      image =
        case Mix.env() do
          :dev ->
            path =
              case title do
                "Scratch" -> "./.postman/scratch.png"
                _ -> "./.postman/question.png"
              end

            %Plug.Upload{
              content_type: "image/png",
              filename: "badge.png",
              path: path
            }

          _ ->
            nil
        end

      badge = %{description: title, name: title, image: image}

      Bokken.Gamification.create_badge(badge)
    end
  end
end

Bokken.Repo.Seeds.Gamification.run
