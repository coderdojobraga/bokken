defmodule Bokken.Accounts.OrganizerAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts.Organizer

  def widgets(_schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Organizers",
        content: Repo.one(from p in Organizer, select: count("*")),
        icon: "user-lock",
        order: 1,
        width: 3
      }
    ]
  end
end
