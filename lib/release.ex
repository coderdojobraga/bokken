defmodule Bokken.Release do
  @moduledoc """
  Module with tasks runnable in production. Once a release is built the tasks
  can be executed using the `eval` command, like this:

  ```console
  $ bin/bokken eval "Bokken.Release.migrate"
  ```

  See https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands
  """
  @app :bokken

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
