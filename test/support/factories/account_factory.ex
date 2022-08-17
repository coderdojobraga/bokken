defmodule Bokken.Factories.AccountFactory do
  # with Ecto
  use ExMachina.Ecto, repo: Bokken.Repo

  alias Bokken.Accounts.{Guardian, Mentor, Ninja, Organizer, User}
  alias Faker.{Avatar, Date, Person, Phone}

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@mail.com"),
      password: "password1234!",
      role: sequence(:role, ["organizer", "guardian", "mentor", "ninja"])
    }
  end

  def guardian_factory do
    user = build(:user, role: "guardian")

    %Guardian{
      photo: Avatar.image_url(sequence(:photo, &"#{&1}.png")),
      first_name: Person.PtPt.first_name(),
      last_name: Person.PtPt.last_name(),
      mobile: Phone.PtPt.cell_number(),
      city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
      user_id: user.id
    }
  end

  def mentor_factory do
    user = build(:user, role: "mentor")

    %Mentor{
      photo: Avatar.image_url(sequence(:photo, &"#{&1}.png")),
      first_name: Person.PtPt.first_name(),
      last_name: Person.PtPt.last_name(),
      mobile: Phone.PtPt.cell_number(),
      major: Enum.random(["Software Engineering", "Computer Science"]),
      trial: Enum.random([true, false]),
      birthday: Date.date_of_birth(18..27),
      user_id: user.id
    }
  end

  def ninja_factory do
    guardian = guardian_factory()
    user = build(:user, role: "ninja")

    %Ninja{
      photo: Avatar.image_url("#{System.unique_integer()}.png"),
      first_name: Person.PtBr.first_name(),
      last_name: Person.PtBr.last_name(),
      birthday: Date.date_of_birth(7..17),
      belt: Enum.random(Ecto.Enum.values(Accounts.Ninja, :belt)),
      city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
      guardian_id: guardian.id,
      user_id: user.id
    }
  end

  def organizer_factory do
    mentor = mentor_factory()
    %Organizer{
      champion: Enum.random([true, false]),
      mentor_id: mentor.id,
      user_id: mentor.user_id
    }
  end
end
