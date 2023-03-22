defmodule Bokken.Repo.Seeds.Documents do
  def run do
    case Bokken.Repo.all(Bokken.Documents.File) do
      [] ->
        [
          "My first project",
          "My first game",
          "My Web Server",
          "Notes on Scratch",
          "Learning strategies for organizing code"
        ]
        |> create_files()

        [
          "Notes on Scratch and other programming languages",
          "How to git good",
          "Notes on Elixir and other witch craft magic"
        ]
        |> create_files(:snippet)

      _ ->
        Mix.shell().error("Found files, aborting seeding files.")
    end
  end

  def create_files(titles) do
    if Mix.env() in [:dev, :test] do
      for title <- titles do
        document = %Plug.Upload{
          content_type: "text/plain",
          filename: "project.txt",
          path: Enum.random(["./.postman/file.txt", "./.postman/file2.txt"])
        }

        %{user_id: user_id} = Enum.random(Bokken.Accounts.list_ninjas())

        file = %{title: title, description: title, document: document, user_id: user_id}

        Bokken.Documents.create_file(file)
      end
    end
  end

  def create_files(titles, :snippet) do
    if Mix.env() in [:dev, :test] do
      for title <- titles do
        document = %Plug.Upload{
          content_type: "text/plain",
          filename: "project.txt",
          path: Enum.random(["./.postman/file.txt", "./.postman/file2.txt"])
        }

        %{user_id: user_id} = Enum.random(Bokken.Accounts.list_ninjas())

        file = %{title: title, description: title, document: document, user_id: user_id}

        Bokken.Documents.create_file(file)
      end
    end
  end
end

Bokken.Repo.Seeds.Documents.run
