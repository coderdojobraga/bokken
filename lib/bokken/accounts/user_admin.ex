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
      role: %{
        filters: [
          {"Guardian", :guardian},
          {"Mentor", :mentor},
          {"Ninja", :ninja},
          {"Organizer", :organizer}
        ]
      },
      verified: nil,
      active: nil,
      registered: nil
    ]
  end

  def form_fields(_) do
    [
      email: nil,
      active: nil,
      password: nil,
      password_hash: nil,
      role: %{choices: [:guardian, :mentor, :ninja, :organizer]},
      registered: nil,
      verified: nil
    ]
  end
end
