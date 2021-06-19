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
      "Scratch",
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
      "Especial Dia da Mãe",
      "Especial Férias",
      "Especial Natal",
      "Semana de Engenharia Informática",
      nil
    ]
    |> create_events()

    # Some Lectures
    [
      "Scratch from scratch",
      "First python program",
      "Learning loops",
      "Practicing conditional statements"
    ]
    |> create_lectures()

    # Some Projects
    [
      "My first project",
      "Learning strategies for organizing code"
    ]
    |> create_files()
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

  def create_events(title) do
    for name <- title do
      random_number = Enum.random(1..100)
      notes = "Great #{random_number} event"

      %{id: location_id} = Enum.random(Bokken.Events.list_locations())
      %{id: team_id} = Enum.random(Bokken.Events.list_teams())

      event = %{
        title: name,
        online: false,
        notes: notes,
        start_time: ~U[2021-08-08 10:00:00.0Z],
        end_time: ~U[2021-08-08 12:30:00.0Z],
        location_id: location_id,
        team_id: team_id
      }

      Bokken.Events.create_event(event)
    end
  end

  def create_badges(titles) do
    for title <- titles do
      image =
        case Mix.env() do
          :dev ->
            path =
              case title do
                "Scratch" -> "./.postman/scratch.png"
                _ -> "./.postman/question.png"
              end

            %Plug.Upload{
              content_type: "image/png",
              filename: "badge.png",
              path: path
            }

          _ ->
            nil
        end

      badge = %{description: title, name: title, image: image}

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
      registered: true,
      active: true,
      role: role
    }
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

    for {ninja, summary} <- Enum.zip(ninjas, summaries) do
      %{id: mentor_id} = Enum.random(Bokken.Accounts.list_mentors())

      %{id: mentor_assistant_1} = Enum.random(Bokken.Accounts.list_mentors())
      %{id: mentor_assistant_2} = Enum.random(Bokken.Accounts.list_mentors())
      %{id: mentor_assistant_3} = Enum.random(Bokken.Accounts.list_mentors())

      %{id: event_id} = Enum.random(Bokken.Events.list_events())
      attendance = Enum.random([:both_present, :both_absent, :ninja_absent, :mentor_absent])

      lecture = %{
        summary: summary,
        mentor_id: mentor_id,
        event_id: event_id,
        ninja_id: ninja.id,
        attendance: attendance,
        assistant_mentors: [mentor_assistant_1, mentor_assistant_2, mentor_assistant_3]
      }

      {:ok, %{id: lecture_id}} = Bokken.Events.create_lecture_assistant(lecture)

      if Mix.env() in [:dev, :test] do
        document = %Plug.Upload{
          content_type: "text/plain",
          filename: "project.txt",
          path: Enum.random(["./.postman/file.txt", "./.postman/file2.txt"])
        }

        file = %{
          title: "Notes about the lesson",
          description: summary,
          document: document,
          lecture_id: lecture_id,
          user_id: ninja.user_id
        }

        Bokken.Documents.create_file(file)
      end
    end
  end

  def create_files(titles) do
    if Mix.env() in [:dev, :test] do
      for title <- titles do
        document = %Plug.Upload{
          content_type: "text/plain",
          filename: "project.txt",
          path: Enum.random(["./.postman/file.txt", "./.postman/file2.txt"])
        }

        %{user_id: user_id} = Enum.random(Bokken.Accounts.list_ninjas())

        file = %{title: title, description: title, document: document, user_id: user_id}

        Bokken.Documents.create_file(file)
      end
    end
  end

  def create_files(titles, :snippet) do
    if Mix.env() in [:dev, :test] do
      for title <- titles do
        document = %Plug.Upload{
          content_type: "text/plain",
          filename: "project.txt",
          path: Enum.random(["./.postman/file.txt", "./.postman/file2.txt"])
        }

        %{user_id: user_id} = Enum.random(Bokken.Accounts.list_ninjas())

        file = %{title: title, description: title, document: document, user_id: user_id}

        Bokken.Documents.create_file(file)
      end
    end
  end

  defp split_names(name) do
    [first_name | other_names] = String.split(name)
    family_names = Enum.join(other_names, " ")
    %{first_name: first_name, last_name: family_names}
  end
end

Bokken.DbSeeder.run()
