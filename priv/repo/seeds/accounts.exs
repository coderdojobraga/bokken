defmodule Bokken.Repo.Seeds.Accounts do
  def run do
    case Bokken.Repo.all(Bokken.Accounts.Guardian) do
      [] ->
        # Great Singers
        [
          "Amalia Rodrigues",
          "Aretha Franklin",
          "Chico Buarque",
          "David Bowie",
          "Diana Ross",
          "Elis Regina",
          "Ella Fitzgerald",
          "Elton John",
          "Etta James",
          "Freddie Mercury",
          "Gordon Matthew Thomas Sting",
          "Jim Morrison",
          "Joni Mitchell",
          "Jorge Palma",
          "Leonard Cohen",
          "Luis Represas",
          "Marvin Gaye",
          "Michael Hutchence",
          "Nina Simone",
          "Paulo de Carvalho",
          "Sergio Godinho",
          "Simone de Oliveira",
          "Tom Jobim"
        ]
        |> create_users(:guardian)

      _ ->
        Mix.shell().error("Found guardians, aborting seeding guardians.")
    end

    case Bokken.Repo.all(Bokken.Accounts.Mentor) do
      [] ->
        # Disney Characters
        [
          "Bo Peep",
          "Bugs Bunny",
          "Buzz Lightyear",
          "Captain Hook",
          "Clara Cluck",
          "Clarabelle Cow",
          "Cruella de Vil",
          "Daisy Duck",
          "Dewey Duck",
          "Doc Hudson",
          "Donald Duck",
          "Eddie Valiant",
          "Horace Horsecollar",
          "Huey Duck",
          "Jessica Rabbit",
          "Judge Doom",
          "Lightning McQueen",
          "Little John",
          "Louie Duck",
          "Maid Marian",
          "Max Goof",
          "Mickey Mouse",
          "Minnie Mouse",
          "Mortimer Mouse",
          "Peter Pan",
          "Potato Head",
          "Prince John",
          "Queen of Hearts",
          "Robin Hood",
          "Roger Rabbit",
          "Sally Carrera",
          "Scrooge McDuck",
          "Speedy Gonzalez",
          "Sheriff of Nottingham",
          "Snow White",
          "Tiger Lily",
          "Tinker Bell",
          "Tweedle Dee",
          "Tweedle Dum",
          "Wendy Darling",
          "White Rabbit"
        ]
        |> create_users(:mentor)

      _ ->
        Mix.shell().error("Found mentors, aborting seeding mentors.")
    end

    case Bokken.Repo.all(Bokken.Accounts.Ninja) do
      [] ->
        # Literature Characters
        [
          "Aberforth Dumbledore",
          "Adrian Mole",
          "Albus Dumbledore",
          "Albus Sverus Potter",
          "Amycus Carrow",
          "Anne Frank",
          "Anne of Green Gables",
          "Argus Filch",
          "Asterix Obelix",
          "Calvin and Hobbes",
          "Charity Burbage",
          "Charlie Brown",
          "Corto Maltese",
          "Curious George",
          "Dudley Dursley",
          "Elphias Doge",
          "Ernie Macmillan",
          "Filius Fitwick",
          "Fleur Delacour",
          "Gabrielle Delacour",
          "George Weasley",
          "Geronimo Stilton",
          "Gilderoy Lockhart",
          "Greg Heffley",
          "Gregory Goyle",
          "Hannah Abott",
          "Harry Potter",
          "Heidi and Marco",
          "Helena Ravenclaw",
          "Hermione Ganger",
          "Horce Slughorn",
          "Huckleberry Finn",
          "Hungry Catterpilar",
          "James Potter",
          "Katie Bell",
          "King Babar",
          "Lilly Evans Potter",
          "Lily Luna Potter",
          "Little Prince",
          "Lucious Malfoy",
          "Lucky Luck",
          "Luna Lovegood",
          "Mafalda Quino",
          "Malala Malala",
          "Marry Cattermole",
          "Michael Corner",
          "Molly Weasley",
          "Nancy Drew",
          "Narcissa Malfoy",
          "Neville Longbottom",
          "Nymphadora Tonks",
          "Padington Bear",
          "Padma Patil",
          "Pansy Parkinson",
          "Peppa Pig",
          "Percy Weasley",
          "Peter Rabbit",
          "Petunia Evans Dursley",
          "Pippi Longstocking",
          "Pomona Sprout",
          "Reginald Cattermole",
          "Reginald Coner",
          "Remus Lupin",
          "Rita Skeeter",
          "Rubeus Hagrid",
          "Rufus Scrimgeour",
          "Rupert Bear",
          "Scooby Doo",
          "Serlock Holmes",
          "Snoopy Dog",
          "Stuart Little",
          "Ted Tonks",
          "Throwfinn Rowle",
          "Tintin Herge",
          "Tom Sawyer",
          "Vernon Dursley",
          "Viktor Krum",
          "Vincent Crabbe",
          "Winnie de Pooh"
        ]
        |> create_users(:ninja)

      _ ->
        Mix.shell().error("Found ninjas, aborting seeding ninjas.")
    end

    case Bokken.Repo.all(Bokken.Accounts.Organizer) do
      [] ->
        # Friends Characters
        [
          "Chandler Bing",
          "Monica Geller",
          "Ross Geller",
          "Joey Tribbiani",
          "Rachel Green",
          "Phoebe Buffay"
        ]
        |> create_users(:organizer)

      _ ->
        Mix.shell().error("Found organizers, aborting seeding organizers.")
    end
  end

  def create_users(characters, role) when role in [:guardian, :mentor, :ninja, :organizer] do
    for character <- characters do
      user = gen_user(character, role)

      names = split_names(character)

      case Bokken.Accounts.create_user(user) do
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))

        {:ok, %{id: user_id}} when role == :guardian ->
          create_guardian(names, user_id)

        {:ok, %{id: user_id}} when role == :mentor ->
          create_mentor(names, user_id)

        {:ok, %{id: user_id}} when role == :ninja ->
          create_ninja(names, user_id)

        {:ok, %{id: user_id}} when role == :organizer ->
          create_organizer(user_id)
      end
    end
  end

  def create_guardian(names, user_id) do
    mobile =
      "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}"

    city = Enum.random(Jason.decode!(File.read!("data/pt/cities.json")))

    photo = nil

    guardian = Enum.into(names, %{user_id: user_id, photo: photo, mobile: mobile, city: city})

    Bokken.Accounts.create_guardian(guardian)
  end

  def create_ninja(names, user_id) do
    birthday = %Date{
      year: Enum.random(1995..2013),
      month: Enum.random(1..12),
      day: Enum.random(1..28)
    }

    belt = Enum.random([nil, :white, :yellow, :blue, :green, :orange, :red, :purple, :black])

    %{id: guardian_id} = Enum.random(Bokken.Accounts.list_guardians())

    photo = nil

    ninja =
      Enum.into(names, %{
        user_id: user_id,
        guardian_id: guardian_id,
        photo: photo,
        belt: belt,
        birthday: birthday
      })

    Bokken.Accounts.create_ninja(ninja)
  end

  def create_mentor(names, user_id) do
    mobile =
      "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}"

    birthday = %Date{
      year: Enum.random(1995..2013),
      month: Enum.random(1..12),
      day: Enum.random(1..28)
    }

    photo = nil

    mentor =
      Enum.into(names, %{
        user_id: user_id,
        mobile: mobile,
        trial: false,
        photo: photo,
        birthday: birthday,
        t_shirt: Enum.random(["extra_small", "small", "medium", "large", "extra_large", "extra_extra_large"])
      })

    Bokken.Accounts.create_mentor(mentor)
  end

  def create_organizer(user_id) do
    organizer = %{
      champion: true,
      user_id: user_id
    }

    Bokken.Accounts.create_organizer(organizer)
  end

  defp gen_user(character, role) do
    email = character |> String.downcase() |> String.replace(~r/\s*/, "")

    %{
      email: email <> "@mail.com",
      password: "password1234",
      verified: true,
      registered: true,
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

Bokken.Repo.Seeds.Accounts.run
