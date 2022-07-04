defmodule Bokken.Repo.Seeds.Events do
  def run do
    case Bokken.Repo.all(Bokken.Events.Team) do
      [] ->
        [
          "Benjamins",
          "Escolinhas",
          "Infantis",
          "Iniciados",
          "Juvenis",
          "Juniores",
          "Seniores",
          "Máximus A",
          "Máximus B",
          "Mínimus A",
          "Mínimus B",
          "Qi",
          "Yin",
          "Yang"
        ]
        |> create_teams()
      _ ->
        Mix.shell().error("Found teams, aborting seeding teams.")
    end

    case Bokken.Repo.all(Bokken.Events.Location) do
      [] ->
        Jason.decode!(File.read!("data/pt/cities.json"))
        |> create_locations()
      _ ->
        Mix.shell().error("Found locations, aborting seeding locations.")
    end

    case Bokken.Repo.all(Bokken.Events.Event) do
      [] ->
        [
          "Especial Dia da Criança",
          "Especial Dia da Mãe",
          "Especial Férias",
          "Especial Natal",
          "Semana de Engenharia Informática",
          nil
        ]
        |> create_events()
      _ ->
        Mix.shell().error("Found events, aborting seeding events.")
    end

    case Bokken.Repo.all(Bokken.Events.Lecture) do
      [] ->
        [
          "Scratch from scratch",
          "First python program",
          "Learning loops",
          "Practicing conditional statements"
        ]
        |> create_lectures()
      _ ->
        Mix.shell().error("Found lectures, aborting seeding lectures.")
    end

    case Bokken.Repo.all(Bokken.Events.Enrollment) do
      [] -> create_enrollments(7)
      _ ->
        Mix.shell().error("Found enrollments, aborting seeding enrollments.")
    end
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

      {:ok, team} = Bokken.Events.create_team(team)

      Enum.take_random(Bokken.Accounts.list_ninjas(), 5)
      |> Enum.map(&Bokken.Accounts.add_ninja_to_team(&1.id, team.id))
    end
  end

  def create_events(title) do
    for name <- title do
      %{id: location_id} = Enum.random(Bokken.Events.list_locations())
      %{id: team_id} = Enum.random(Bokken.Events.list_teams())

      event = %{
        title: name,
        online: false,
        spots_available: Enum.random(15..30),
        notes: "Great #{Enum.random(1..100)} event",
        start_time: ~U[2023-08-08 10:00:00.0Z],
        end_time: ~U[2023-08-08 12:30:00.0Z],
        enrollments_open: ~U[2022-07-08 12:30:00.0Z],
        enrollments_close: ~U[2023-08-07 12:30:00.0Z],
        location_id: location_id,
        team_id: team_id
      }

      Bokken.Events.create_event(event)
    end

    %{id: location_id} = Enum.random(Bokken.Events.list_locations())
    %{id: team_id} = Enum.random(Bokken.Events.list_teams())

    event = %{
      title: "Closed",
      online: false,
      spots_available: Enum.random(15..30),
      notes: "Great #{Enum.random(1..100)} event",
      start_time: ~U[2023-08-08 10:00:00.0Z],
      end_time: ~U[2023-08-08 12:30:00.0Z],
      enrollments_open: ~U[2022-07-08 12:30:00.0Z],
      enrollments_close: ~U[2022-07-09 12:30:00.0Z],
      location_id: location_id,
      team_id: team_id
    }

    Bokken.Events.create_event(event)
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

  def create_enrollments(count) do
    ninjas = Bokken.Accounts.list_ninjas()
    events = Bokken.Events.list_events()

    for i <- 1..count do
      %{id: ninja_id} = Enum.random(ninjas)
      %{id: event_id}  = Enum.random(events);
      enrollment = %{
        event_id: event_id,
        ninja_id: ninja_id,
        accepted: false,
        notes: "First session"
      }
    end
  end

end

Bokken.Repo.Seeds.Events.run
