defmodule Mix.Tasks.Test.Run.Newman do
  @moduledoc """
  Runs newman, a Postman CLI.
  """
  use Mix.Task

  @spec run(any) :: list
  def run(_) do
    Mix.Task.run("app.start")

    Mix.shell().cmd(
      "newman run .postman/collection.json --environment .postman/env.#{Mix.env()}.json"
    )
  end
end
