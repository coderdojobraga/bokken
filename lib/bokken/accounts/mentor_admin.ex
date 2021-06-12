defmodule Bokken.Accounts.MentorAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts.Mentor

  def widgets(_schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Mentors",
        content: Repo.one(from p in Mentor, select: count("*")),
        icon: "chalkboard-teacher",
        order: 1,
        width: 3
      }
    ]
  end
end
