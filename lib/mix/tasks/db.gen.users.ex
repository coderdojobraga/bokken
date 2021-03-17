defmodule Mix.Tasks.Db.Gen.Users do
  @moduledoc """
  A task to populate the database with some users.
  """
  use Mix.Task
  alias Bokken.Cities.Citieslist

  @spec run(any) :: list
  def run(_) do
    Mix.Task.run("app.start")

    # Disney Characters
    [
      "Peter Pan",
      "Buzz Lightyear",
      "Pato Donald",
      "Cruella de Vil",
      "Branca de Neve"
    ]
    |> create_users(:mentor)

    # Great Singers
    [
      "Amalia Rodrigues",
      "Freddie Mercury",
      "Gordon Matthew Thomas Sting",
      "Elis Regina",
      "Aretha Franklin"
    ]
    |> create_users(:guardian)
  end

  defp create_users(characters, role) when role in [:mentor] do
    for character <- characters do
      user = gen_user(character, role)

      names = split_names(character)

      case Bokken.Accounts.create_user(user) do
        {:ok, %{id: user_id}} when role == :mentor ->
          mobile =
            "+351 9#{Enum.random([1, 2, 3, 6])}#{
              for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()
            }"

          birthday = %Date{
            year: Enum.random(1995..2013),
            month: Enum.random(1..12),
            day: Enum.random(1..28)
          }

          mentor =
            Enum.into(names, %{user_id: user_id, mobile: mobile, trial: false, birthday: birthday})

          Bokken.Accounts.create_mentor(mentor)
      end
    end
  end

  defp create_users(characters, role) when role in [:guardian] do
    for character <- characters do
      user = gen_user(character, role)

      names = split_names(character)

      case Bokken.Accounts.create_user(user) do
        {:ok, %{id: user_id}} when role == :guardian ->
          mobile =
            "+351 9#{Enum.random([1, 2, 3, 6])}#{
              for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()
            }"

          city = Enum.random(Citieslist.get_all_cities())

          guardian = Enum.into(names, %{user_id: user_id, mobile: mobile, city: city})

          Bokken.Accounts.create_guardian(guardian)
      end
    end
  end

  defp gen_user(character, role) do
    email = character |> String.downcase() |> String.replace(~r/\s*/, "")

    %{
      email: email <> "@mail.com",
      password: "password1234",
      verified: true,
      active: true,
      role: role
    }
  end

  defp split_names(name) do
    [first_name | other_names] = String.split(name)
    family_names = Enum.join(other_names, " ")
    %{first_name: first_name, last_name: family_names}
  end
end
