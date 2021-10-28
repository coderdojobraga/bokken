defmodule Bokken.Accounts.GuardianAdmin do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian
  alias Bokken.Uploaders.Avatar

  @portuguese_cities Jason.decode!(File.read!("data/pt/cities.json"))

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

  def form_fields(_) do
    [
      first_name: nil,
      last_name: nil,
      mobile: nil,
      city: %{choices: @portuguese_cities}
    ]
  end
end
