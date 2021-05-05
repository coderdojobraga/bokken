defmodule Mix.Tasks.Test.Run.Newman do
  @moduledoc """
  Runs newman, a Postman CLI.
  """
  use Mix.Task

  @spec run(any) :: list
  def run(_) do
    Mix.Task.run("app.start")

    result_status =
      Mix.shell().cmd(
        "newman run .postman/collection.json --environment .postman/env.#{Mix.env()}.json"
      )

    exit({:shutdown, result_status})
  end
end
