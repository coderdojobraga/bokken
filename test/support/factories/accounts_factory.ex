defmodule Bokken.Factories.AccountFactory do
  @moduledoc """
  A factory to generate account related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Accounts.{Guardian, Mentor, Ninja, Organizer, User}
      alias Faker.{Avatar, Date, Person, Phone}

      defp add_mobile_prefix(number), do: "+351" <> number

      def user_factory do
        %User{
          email: sequence(:email, &"email-#{&1}@mail.com"),
          password_hash: Argon2.hash_pwd_salt("password1234!"),
          role: sequence(:role, ["organizer", "guardian", "mentor", "ninja"])
        }
      end

      def guardian_factory do
        %Guardian{
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          mobile: add_mobile_prefix(Phone.PtPt.cell_number()),
          city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
          user: build(:user, role: :guardian)
        }
      end

      def mentor_factory do
        %Mentor{
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          mobile: add_mobile_prefix(Phone.PtPt.cell_number()),
          major: Enum.random(["Software Engineering", "Computer Science"]),
          trial: Enum.random([true, false]),
          birthday: Date.date_of_birth(18..27),
          user: build(:user, role: :mentor)
        }
      end

      def ninja_factory do
        %Ninja{
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          birthday: Date.date_of_birth(7..16),
          belt: Enum.random(Ecto.Enum.values(Ninja, :belt)),
          guardian: build(:guardian),
          user: build(:user, role: :ninja)
        }
      end

      def organizer_factory do
        mentor = build(:mentor)

        %Organizer{
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          champion: true,
          mentor: mentor,
          user: mentor.user
        }
      end
    end
  end
end
