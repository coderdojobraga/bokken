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
  @spec list_teams(map()) :: list(Team.t())
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

  @spec list_events(map()) :: list(Event.t())
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
  Gets the next event i.e., the event which has the closest date in the future to today.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_next_event!()
      %Event{}

      iex> get_next_event!()
      ** (Ecto.NoResultsError)

  """
  def get_next_event!(preloads \\ []) do
    now = DateTime.utc_now()

    Event
    |> where([e], e.start_time >= ^now)
    |> order_by([e], asc: e.start_time)
    |> limit(1)
    |> Repo.one!()
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

      iex> list_lectures(%{"ninja_id" => 123})
      [%Lecture{}, ...]

  """
  def list_lectures(params, preloads \\ [])

  def list_lectures(%{"event_id" => event_id}, preloads) do
    Lecture
    |> where([l], l.event_id == ^event_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_lectures(%{"mentor_id" => mentor_id}, preloads) do
    Lecture
    |> where([l], l.mentor_id == ^mentor_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_lectures(%{"ninja_id" => ninja_id}, preloads) do
    Lecture
    |> where([l], l.ninja_id == ^ninja_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_lectures(_params, preloads) do
    Lecture
    |> Repo.all()
    |> Repo.preload(preloads)
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

  def get_lectures_from_event(event_id, preloads \\ []) do
    Lecture 
    |> where([l], l.event_id == ^event_id)
    |> Repo.all()
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

    ids =
      attrs
      |> then(fn x ->
        cond do
          x["assistant_mentors"] ->
            Map.get(attrs, "assistant_mentors")

          x[:assistant_mentors] ->
            Map.get(attrs, :assistant_mentors)
        end
      end)

    add_mentor_assistants(l.id, ids)

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
    %Ecto.Changeset{}

  """
  def change_lecture(%Lecture{} = lecture, attrs \\ %{}) do
    Lecture.changeset(lecture, attrs)
  end

  alias Bokken.Events.Enrollment

  @doc """
  Returns the list of enrollments.

  ## Examples

      iex> list_enrollments(123)
      [%Enrollment{}, ...]

      iex> list_enrollments()
      [%Enrollment{}, ...]

  """
  def list_enrollments(%{"ninja_id" => ninja_id}) do
    Enrollment
    |> where([e], e.ninja_id == ^ninja_id)
    |> Repo.all()
    |> Repo.preload([:ninja, :event])
  end

  def list_enrollments(%{"event_id" => event_id}) do
    Enrollment
    |> where([e], e.event_id == ^event_id)
    |> Repo.all()
    |> Repo.preload([:ninja, :event])
  end

  def list_enrollments do
    Enrollment
    |> Repo.all()
    |> Repo.preload([:ninja, :event])
  end

  @doc """
  Gets a single enrollment.

  Returns nil if the Enrollment does not exist.

  ## Examples

      iex> get_enrollment(123)
      %Enrollment{}

      iex> get_enrollment(456)
      nil

  """
  def get_enrollment(id, preloads \\ []) do
    Enrollment
    |> Repo.get(id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates an enrollment.

  ## Examples

      iex> create_enrollment(%{field: value})
      {:ok, %Enrollment{}}

      iex> create_enrollment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(event, attrs \\ %{}) do
    cur_time = DateTime.utc_now()

    if DateTime.compare(event.enrollments_open, cur_time) == :lt and
         DateTime.compare(event.enrollments_close, cur_time) == :gt do
      %Enrollment{}
      |> Enrollment.changeset(attrs)
      |> Repo.insert()
    else
      {:error, "Enrollments are closed"}
    end
  end

  @doc """
  Updates an enrollment.

  ## Examples

      iex> update_enrollment(enrollment, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(enrollment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enrollment(%Enrollment{} = enrollment, attrs) do
    enrollment
    |> Enrollment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an enrollment.

  ## Examples

      iex> delete_enrollment(enrollment)
      {:ok, %Enrollment{}}

      iex> delete_enrollment(enrollment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(%Enrollment{} = enrollment) do
    event = get_event!(enrollment.event_id)
    cur_time = DateTime.utc_now()

    if DateTime.compare(event.start_time, cur_time) == :gt do
      Repo.delete(enrollment)
    else
      {:error, "Cannot delete enrollment of past session"}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking enrollment changes.

  ## Examples

      iex> change_enrollment(enrollment)
      %Ecto.Changeset{data: %Enrollment{}}

  """
  def change_enrollment(%Enrollment{} = enrollment, attrs \\ %{}) do
    Event.changeset(enrollment, attrs)
  end

  alias Bokken.Events.Availability

  @doc """
  Returns the list of the availabilities.

  ## Examples

      iex> list_availabilities([:mentor])
      [%Availability{}, ...]

      iex> list_availabilities(123, [:mentor, :event])
      [%Availability{}, ...]

      iex> list_availabilities(123)
      [%Availability{}, ...]

  """
  def list_availabilities(preloads) when is_list(preloads) do
    Availability
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_availabilities(%{"event_id" => event_id}, preloads \\ []) do
    Availability
    |> where([a], a.event_id == ^event_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single availability.

  Raises `Ecto.NoResultsError` if the Badge does not exist.

  ## Examples

      iex> get_availability!(123)
      %Availability{}

      iex> get_availability!(456)
      ** (Ecto.NoResultsError)

  """
  def get_availability!(id, preloads \\ []) do
    Availability
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates an availability.

  ## Examples

      iex> create_availability(%{field: value})
      {:ok, %Availability{}}

      iex> create_availability(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_availability(event, attrs \\ %{}) do
    current_time = DateTime.utc_now()
    first_comparison = DateTime.compare(event.enrollments_open, current_time)
    second_comparison = DateTime.compare(event.enrollments_close, current_time)

    if first_comparison == :lt and second_comparison == :gt do
      %Availability{}
      |> Availability.changeset(attrs)
      |> Repo.insert()
    else
      {:error, "You can't create the availability for an event with closed enrollments"}
    end
  end

  @doc """
  Updates an availability.

  ## Examples

      iex> update_availability(availability, %{field: new_value})
      {:ok, %Availability{}}

      iex> update_availability(availability, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_availability(%Availability{} = availability, attrs) do
    availability
    |> Availability.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking availability changes.

  ## Examples

      iex> change_availability(availability)
      %Ecto.Changeset{data: %Availability{}}

  """
  def change_availability(%Availability{} = availability, attrs \\ %{}) do
    Availability.changeset(availability, attrs)
  end
end
