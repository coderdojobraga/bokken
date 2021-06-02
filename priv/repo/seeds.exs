defmodule Bokken.DbSeeder do
  @moduledoc """
  Script for populating the database with fake data. You can run it as:
       mix run priv/repo/seeds.exs
  """

  def run do
    # Great Singers
    [
      "Amalia Rodrigues",
      "Freddie Mercury",
      "Gordon Matthew Thomas Sting",
      "Elis Regina",
      "Aretha Franklin",
      "David Bowie",
      "Etta James",
      "Leonard Cohen",
      "Marvin Gaye",
      "Jim Morrison",
      "Michael Hutchence",
      "Elton John",
      "Joni Mitchell",
      "Diana Ross",
      "Ella Fitzgerald",
      "Nina Simone",
      "Tom Jobim",
      "Chico Buarque",
      "Luis Represas",
      "Simone de Oliveira",
      "Paulo de Carvalho",
      "Sergio Godinho",
      "Jorge Palma"
    ]
    |> create_users(:guardian)

    # Disney Characters
    [
      "Peter Pan",
      "Buzz Lightyear",
      "Cruella de Vil",
      "Snow White",
      "Mickey Mouse",
      "Minnie Mouse",
      "Donald Duck",
      "Daisy Duck",
      "Huey Duck",
      "Dewey Duck",
      "Louie Duck",
      "Scrooge McDuck",
      "Clarabelle Cow",
      "Max Goof",
      "Horace Horsecollar",
      "Clara Cluck",
      "Mortimer Mouse",
      "Queen of Hearts",
      "Tweedle Dee",
      "Tweedle Dum",
      "White Rabbit",
      "Captain Hook",
      "Tiger Lily",
      "Tinker Bell",
      "Wendy Darling",
      "Prince John",
      "Robin Hood",
      "Sheriff of Nottingham",
      "Little John",
      "Maid Marian",
      "Eddie Valiant",
      "Jessica Rabbit",
      "Judge Doom",
      "Roger Rabbit",
      "Buzz Lightyear",
      "Potato Head",
      "Bo Peep",
      "Lightning McQueen",
      "Sally Carrera",
      "Doc Hudson"
    ]
    |> create_users(:mentor)
    |> create_organizers()

    # Pokémons
    [
      "Bulbasaur Fushigidane",
      "Charmander Hitokage",
      "Squirtle Zenigame",
      "Pikachu Nidorina",
      "Nidorina Pikachu",
      "Psyduck Kodakku",
      "Snorlax Kabigon",
      "Kindwurm Draschel",
      "Brutalanda Tanhel",
      "Metang Metagross",
      "Regirock Regice",
      "Registeel Latias",
      "Latios Kyogre",
      "Groudon Rayquaza",
      "Jirachi Deoxys",
      "Chelast Chelcarain",
      "Chelterrar Panflam",
      "Panpyro Panferno",
      "Plinfa Pliprin",
      "Impoleon Staralili",
      "Staravia Staraptor",
      "Bidiza Bidifas",
      "Zirpurze Zirpeise",
      "Sheinux Luxio",
      "Luxtra Knospi",
      "Roserade Koknodon",
      "Rameidon Schilterus",
      "Bollterus Burmy",
      "Burmadame Moterpel",
      "Wadribie Honweisel",
      "Pachirisu Bamelin",
      "Bojelin Kikugi",
      "Kinoso Schalellos",
      "Gastrodon Ambidiffel",
      "Driftlon Drifzepeli",
      "Haspiror Schlapor",
      "Traunmagil Kramshef",
      "Charmian Shnurgarst",
      "Klingplim Skunkapuh",
      "Skunktank Bronzel",
      "Bronzong Mobai",
      "Pantimimi Wonneira",
      "Plaudagei Kryppuk",
      "Kaumalat Knarksel",
      "Knakrack Mampfaxo",
      "Riolu Lucario",
      "Hippopotas Hippoterus",
      "Pionskora Piondragi",
      "Glibunkel Toxiquak",
      "Venuflibis Finneon",
      "Lumineon Mantirps",
      "Shnebedeck Rexblisar",
      "Snibunna Magnezone",
      "Schlurplek Rihornior",
      "Tangoloss Elevoltek",
      "Magbrant Togekiss",
      "Yanmega Folipurba",
      "Glaziola Skorgro",
      "Mamutel Porygon-Z",
      "Galagladi Voluminas",
      "Zwirrfinst Frosdedje",
      "Rotom Selfe",
      "Vesprit Tobutz",
      "Dialga Palkia",
      "Heatran Regigigas",
      "Giratina Cresselia",
      "Phione Manaphy",
      "Darkrai Shaymin",
      "Arceus Victini",
      "Serpifeu Efoserp",
      "Serpiroyal Floink",
      "Ferkokel Flambirex",
      "Ottaro Zwottronin",
      "Admurai Nagelotz",
      "Kukmarda Yorkleff",
      "Terribark Bissbark",
      "Felilou Kleoparda",
      "Vegimak Vegichita",
      "Grillmak Grillchita",
      "Sodamak Sodachita",
      "Somniam Somnivora",
      "Dusselgurr Navitaub",
      "Fasasnob Elezeba",
      "Zebritz Kiesling"
    ]
    |> create_users(:ninja)

    [
      "Loop Master",
      "My First Project",
      "Finished 5 Projects",
      "Finished 10 Projects",
      "Conditions Master"
    ]
    |> create_badges()

    # Great Teams
    [
      "Yin",
      "Yang",
      "Qi"
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
      "Especial dia da Mãe",
      "Especial Natal"
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
      attendance = Enum.random([:both_presente, :both_absent, :ninja_absent, :mentor_absent])

      IO.inspect(attendance)

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
