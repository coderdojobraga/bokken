defmodule Bokken.Factories.AccountFactory do
  @moduledoc false
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
        user = build(:user, role: "guardian")

        %Guardian{
          # photo: Avatar.image_url(sequence(:photo, &"#{&1}.png")),
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          mobile: add_mobile_prefix(Phone.PtPt.cell_number()),
          city: Enum.random(Jason.decode!(File.read!("data/pt/cities.json"))),
          user: user
        }
      end

      def mentor_factory do
        user = build(:user, role: "mentor")

        %Mentor{
          photo: Avatar.image_url(sequence(:photo, &"#{&1}.png")),
          first_name: Person.PtBr.first_name(),
          last_name: Person.PtBr.last_name(),
          mobile: add_mobile_prefix(Phone.PtPt.cell_number()),
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
  end
end
