defmodule Bokken.DbSeeder do
  @moduledoc """
  Script for populating the database with fake data. You can run it as:
       mix run priv/repo/seeds.exs
  """

  def run do
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
    |> create_organizers()

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

    [
      "Conditions Master",
      "Finished 5 Projects",
      "Finished 10 Projects",
      "Loop Master",
      "My First Project"
    ]
    |> create_badges()

    # Great Teams
    [
      "Qi",
      "Yin",
      "Yang"
    ]
    |> create_teams()

    # Some Locations
    [
      "Braga",
      "Guimarães",
      "Vieira do Minho"
    ]
    |> create_locations()

    [
      "Especial Dia da Criança",
      "Especial Dia da Mae",
      "Especial Ferias",
      "Especial Natal",
      "Semana de Engenharia Informatica"
    ]
    |> create_new_events()

    # Some Lectures
    [
      "Scratch from scratch",
      "First python program",
      "Learning loops",
      "Practicing conditional statements"
    ]
    |> create_lectures()
  end

  def create_locations(names) do
    for name <- names do
      random = Enum.random(1..100)
      address = "Rua da Estrada, n.º #{random}, #{name}"

      location = %{name: name, address: address}

      Bokken.Events.create_location(location)
    end
  end

  def create_teams(names) do
    for name <- names do
      description = "#{name} is the best team ever"

      team = %{description: description, name: name}

      Bokken.Events.create_team(team)
    end
  end

  def create_new_events(title) do
    for name <- title do
      randomNumber = Enum.random(1..100)
      notes = "Great #{randomNumber} event"

      %{id: location_id} = Enum.random(Bokken.Events.list_locations())
      %{id: team_id} = Enum.random(Bokken.Events.list_teams())

      event = %{
        title: name,
        online: false,
        notes: notes,
        location_id: location_id,
        team_id: team_id
      }

      Bokken.Events.create_event(event)
    end
  end

  def create_badges(names) do
    for character <- names do
      random = Enum.random(1..100)

      image = "https://robohash.org/#{random}"
      description = character

      badge = %{description: description, name: character, image: image}

      Bokken.Gamification.create_badge(badge)
    end
  end

  def create_users(characters, role) when role in [:guardian, :mentor, :ninja] do
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

  def create_guardian(names, user_id) do
    mobile =
      "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}"

    city = Enum.random(Jason.decode!(File.read!("data/pt/cities.json")))

    photo = "https://robohash.org/#{names.first_name}-#{names.last_name}"

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

    photo = "https://robohash.org/#{names.first_name}-#{names.last_name}"

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

    photo = "https://robohash.org/#{names.first_name}-#{names.last_name}"

    mentor =
      Enum.into(names, %{
        user_id: user_id,
        mobile: mobile,
        trial: false,
        photo: photo,
        birthday: birthday
      })

    Bokken.Accounts.create_mentor(mentor)
  end

  def create_organizers(mentors) do
    mentors = Enum.take(mentors, 2)

    for m <- mentors do
      mentor = elem(m, 1)

      organizer = %{
        champion: true,
        user_id: mentor.user_id,
        mentor_id: mentor.id
      }

      Bokken.Accounts.create_organizer(organizer)
    end
  end

  def create_lectures(summaries) do
    ninjas = Bokken.Accounts.list_ninjas()

    list_tuples_summary_ninja = Enum.zip(ninjas, summaries)

    for summary_ninja <- list_tuples_summary_ninja do
      %{id: mentor_id} = Enum.random(Bokken.Accounts.list_mentors())

      %{id: mentor_assistant_1} = Enum.random(Bokken.Accounts.list_mentors())
      %{id: mentor_assistant_2} = Enum.random(Bokken.Accounts.list_mentors())
      %{id: mentor_assistant_3} = Enum.random(Bokken.Accounts.list_mentors())

      %{id: event_id} = Enum.random(Bokken.Events.list_events())
      attendance = Enum.random([:both_present, :both_absent, :ninja_absent, :mentor_absent])

      summary = elem(summary_ninja, 1)
      ninja = elem(summary_ninja, 0)

      lecture = %{
        summary: summary,
        mentor_id: mentor_id,
        event_id: event_id,
        ninja_id: ninja.id,
        attendance: attendance,
        assistant_mentors: [mentor_assistant_1, mentor_assistant_2, mentor_assistant_3]
      }

      Bokken.Events.create_lecture_assistant(lecture)
    end
  end

  defp split_names(name) do
    [first_name | other_names] = String.split(name)
    family_names = Enum.join(other_names, " ")
    %{first_name: first_name, last_name: family_names}
  end
end

Bokken.DbSeeder.run()
