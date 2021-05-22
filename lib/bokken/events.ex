defmodule Bokken.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Events.{LectureMentorAssistant, Team}
  alias Bokken.Repo

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  @spec list_teams(map()) :: list(%Team{})
  def list_teams(args \\ %{})

  def list_teams(%{"mentor_id" => mentor_id}) do
    mentor_id
    |> Accounts.get_mentor!([:teams])
    |> Map.fetch!(:teams)
  end

  def list_teams(%{"ninja_id" => ninja_id}) do
    ninja_id
    |> Accounts.get_ninja!([:teams])
    |> Map.fetch!(:teams)
  end

  def list_teams(_args) do
    Team
    |> Repo.all()
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, preloads \\ []) do
    Repo.get!(Team, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias Bokken.Events.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id, preloads \\ []) do
    Repo.get!(Location, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  alias Bokken.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """

  @spec list_events(map()) :: list(%Event{})
  def list_events(args \\ %{})

  def list_events(%{"team_id" => team_id}) do
    team_id
    |> Events.get_team!([:events])
    |> Map.fetch!(:events)
  end

  def list_events(%{"location_id" => location_id}) do
    location_id
    |> Events.get_location!([:events])
    |> Map.fetch!(:events)
  end

  def list_events(_args) do
    Event
    |> Repo.all()
    |> Repo.preload([:location, :team])
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id, preloads \\ []) do
    Repo.get!(Event, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Bokken.Events.Lecture

  @doc """
  Returns the list of lectures.

  ## Examples

      iex> list_lectures()
      [%Lecture{}, ...]

  """

  def list_lectures do
    Lecture
    |> Repo.all()
    |> Repo.preload([:ninja, :event, :mentor, :assistant_mentors])
  end

  @doc """
  Gets a single lecture.

  Raises `Ecto.NoResultsError` if the Lecture does not exist.

  ## Examples

      iex> get_lecture!(123)
      %Lecture{}

      iex> get_lecture!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lecture!(id, preloads \\ []) do
    Lecture
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a lecture.

  ## Examples

      iex> create_lecture(%{field: value})
      {:ok, %Lecture{}}

      iex> create_lecture(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lecture(attrs \\ %{}) do
    %Lecture{}
    |> Lecture.changeset(attrs)
    |> Repo.insert()
  end

  def create_lecture_assistant(attrs \\ %{}) do
    {:ok, %Lecture{} = l} = %Lecture{} |> Lecture.changeset(attrs) |> Repo.insert()

    if attrs["assistant_mentors"] do
      ids = Map.get(attrs, "assistant_mentors")
      add_mentor_assistants(l.id, ids)
    end

    if attrs[:assistant_mentors] do
      ids = Map.get(attrs, :assistant_mentors)
      add_mentor_assistants(l.id, ids)
    end

    try do
      {:ok, get_lecture!(l.id, [:assistant_mentors])}
    rescue
      e in Repo -> {:error, e}
    end
  end

  defp add_mentor_assistants(lecture_id, list_ids) do
    for assistant_id <- list_ids do
      %LectureMentorAssistant{}
      |> LectureMentorAssistant.changeset(%{
        lecture_id: lecture_id,
        mentor_id: assistant_id
      })
      |> Repo.insert()
    end
  end

  @doc """
  Updates a lecture.

  ## Examples

      iex> update_lecture(lecture, %{field: new_value})
      {:ok, %Lecture{}}

      iex> update_lecture(lecture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lecture(%Lecture{} = lecture, attrs) do
    lecture
    |> Lecture.changeset(attrs)
    |> Repo.update()
  end

  def update_lecture_assistant_mentors(id, attrs) do
    ids = Map.get(attrs, "assistant_mentors")
    update_mentor_assistants(id, ids)

    try do
      {:ok, get_lecture!(id, [:assistant_mentors])}
    rescue
      e in Repo -> {:error, e}
    end
  end

  defp update_mentor_assistants(lecture_id, list_ids) do
    query =
      from l in LectureMentorAssistant,
        where: l.lecture_id == ^lecture_id

    Repo.delete_all(query)
    add_mentor_assistants(lecture_id, list_ids)
  end

  @doc """
  Deletes a lecture.

  ## Examples

      iex> delete_lecture(lecture)
      {:ok, %Lecture{}}

      iex> delete_lecture(lecture)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lecture(%Lecture{} = lecture) do
    Repo.delete(lecture)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lecture changes.

  ## Examples

      iex> change_lecture(lecture)
      %Ecto.Changeset{data: %Lecture{}}

  """
  def change_lecture(%Lecture{} = lecture, attrs \\ %{}) do
    Lecture.changeset(lecture, attrs)
  end
end
