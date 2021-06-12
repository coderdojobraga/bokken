defmodule Bokken.Accounts.GuardianAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian
  alias Bokken.Accounts.User
  alias Bokken.Uploaders.Avatar

  def widgets(_schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Guardians",
        content: Repo.one(from p in Guardian, select: count("*")),
        icon: "user-shield",
        order: 1,
        width: 3
      }
    ]
  end

  def index(_) do
    [
      id: nil,
      name: %{value: &"#{&1.first_name} #{&1.last_name}"},
      mobile: nil,
      city: nil,
      user_id: %{
        name: "Email",
        value: &Accounts.get_user!(&1.user_id).email
      },
      photo: %{value: &Avatar.url({&1.photo, &1}, :thumb)}
    ]
  end
end
