defmodule Bokken.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bokken.Accounts` context.
  """

  alias Bokken.Accounts
  alias Faker.{Avatar, Date, Person, Phone}

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def valid_guardian_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      photo: Avatar.image_url("#{System.unique_integer()}.png"),
      first_name: Person.PtBr.first_name(),
      last_name: Person.PtBr.last_name(),
      mobile: Phone.PtPt.cell_number(),
      city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json")))
    })
  end

  def valid_mentor_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      photo: Avatar.image_url("#{System.unique_integer()}.png"),
      first_name: Person.PtBr.first_name(),
      last_name: Person.PtBr.last_name(),
      mobile: Phone.PtPt.cell_number(),
      city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
      major: "Software Engineering",
      birthday: Date.date_of_birth(18..27)
    })
  end

  def valid_ninja_attributes(attrs \\ %{}) do
    guardian = user_fixture(%{role: :guardian})

    Enum.into(attrs, %{
      photo: Avatar.image_url("#{System.unique_integer()}.png"),
      first_name: Person.PtBr.first_name(),
      last_name: Person.PtBr.last_name(),
      birthday: Date.date_of_birth(7..17),
      belt: Enum.random(Ecto.Enum.values(Accounts.Ninja, :belt)),
      city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
      guardian_id: guardian.id
    })
  end

  def valid_organizer_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      champion: true
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.sign_up_user()

    {:ok, user} = Accounts.update_user(user, %{active: true})

    attrs =
      case user.role do
        :guardian -> valid_guardian_attributes()
        :mentor -> valid_mentor_attributes()
        :ninja -> valid_ninja_attributes()
        :organizer -> valid_organizer_attributes()
      end

    {:ok, user} = Accounts.register_user(user, attrs)

    user
  end
end
