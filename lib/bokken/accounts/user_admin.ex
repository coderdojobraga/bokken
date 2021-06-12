defmodule Bokken.Accounts.UserAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts.User

  def widgets(_schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Users",
        content: Repo.one(from p in User, select: count("*")),
        icon: "user",
        order: 2,
        width: 6
      }
    ]
  end

  def index(_) do
    [
      id: nil,
      email: nil,
      role: nil,
      verified: nil,
      active: nil,
      registered: %{
        value: fn user ->
          user = Repo.preload(user, [user.role])

          [
            mentor: user.mentor,
            guardian: user.guardian,
            ninja: user.ninja,
            organizer: user.organizer
          ]
          |> Keyword.get(user.role)
          |> then(&(Ecto.assoc_loaded?(&1) and not is_nil(&1)))
        end
      }
    ]
  end
end
