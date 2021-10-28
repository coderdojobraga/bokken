defmodule Bokken.Accounts.NinjaAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja
  alias Bokken.Uploaders.Avatar

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

  def index(_) do
    [
      id: nil,
      name: %{value: &"#{&1.first_name} #{&1.last_name}"},
      belt: nil,
      birthday: nil,
      user_id: %{
        name: "Email",
        value: &(&1.user_id && Accounts.get_user!(&1.user_id).email)
      },
      photo: %{value: &Avatar.url({&1.photo, &1}, :thumb)}
    ]
  end

  def form_fields(_) do
    [
      first_name: nil,
      last_name: nil,
      belt: %{
        choices: [
          {"No belt", nil},
          :white,
          :yellow,
          :blue,
          :green,
          :orange,
          :red,
          :purple,
          :black
        ]
      },
      birthday: nil,
      notes: %{type: :richtext, rows: 4}
    ]
  end
end
