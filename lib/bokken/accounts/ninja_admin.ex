defmodule Bokken.Accounts.NinjaAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts.Ninja

  def widgets(_schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Ninjas",
        content: Repo.one(from p in Ninja, select: count("*")),
        icon: "user-ninja",
        order: 1,
        width: 3
      }
    ]
  end
end
