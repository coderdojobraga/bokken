defmodule Bokken.Accounts.MentorAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor
  alias Bokken.Uploaders.Avatar

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

  def index(_) do
    [
      id: nil,
      name: %{value: &"#{&1.first_name} #{&1.last_name}"},
      mobile: nil,
      birthday: nil,
      major: nil,
      trial: nil,
      user_id: %{
        name: "Email",
        value: &Accounts.get_user!(&1.user_id).email
      },
      photo: %{value: &Avatar.url({&1.photo, &1}, :thumb)}
    ]
  end
end
