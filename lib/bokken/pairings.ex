defmodule Bokken.Pairings do
  import Ecto.Query, warn: false

  alias Bokken.{Repo, HungarianAlgorithm, Events}

  @doc """
  Creates lectures for an event.
  ## Examples
      iex> create_pairings(123)
      [%Lecture{}]
  """
  def create_pairings(event_id) do
    available_mentors = get_available_mentors(event_id)
    available_ninjas = get_available_ninjas(event_id)

    pairings_table = pairings_table(available_ninjas, available_mentors)

    matches =
      create_matrix(pairings_table)
      |> HungarianAlgorithm.compute()

    create_lectures(pairings_table, matches, event_id)
  end

  @doc """
  Gets all available mentors for an event.
  ## Examples
      iex> get_available_mentors(123)
      [%Mentor{}]
  """
  def get_available_mentors(event_id) do
    query =
      from m in Bokken.Accounts.Mentor,
        join: a in Bokken.Events.Availability,
        on: m.id == a.mentor_id,
        where: a.is_available and a.event_id == ^event_id,
        preload: [:skills]

    Repo.all(query)
  end

  @doc """
  Gets all available ninjas for an event.
  ## Examples
      iex> get_available_ninjas(123)
      [%Ninja{}]
  """
  def get_available_ninjas(event_id) do
    query =
      from n in Bokken.Accounts.Ninja,
        join: e in Bokken.Events.Enrollment,
        on: n.id == e.ninja_id,
        where: e.accepted and e.event_id == ^event_id,
        preload: [:skills]

    Repo.all(query)
  end

  # Creates a table of pairings between ninjas and mentors to be used after the
  # hungarian algorirthm returns all the matches.
  defp pairings_table([], _rest_mentors), do: []

  defp pairings_table([ninja | rest_ninjas], mentors) do
    row =
      Enum.map(mentors, fn mentor ->
        %{ninja: ninja, mentor: mentor, score: 100 - score(ninja.skills, mentor.skills)}
      end)

    [row | pairings_table(rest_ninjas, mentors)]
  end

  # Returns a score of comapatibility between a ninja and a mentor bases on the
  # percentage of skills matching.
  # If the ninja and the mentor have the exact same skills then the score is 100.
  defp score(ninja_skills, mentor_skills) do
    matching_skills = matching_skills(ninja_skills, mentor_skills)

    total_skills =
      Enum.concat(ninja_skills, mentor_skills)
      |> Enum.frequencies()
      |> Enum.count()

    if matching_skills == 0 do
      0
    else
      matching_skills / total_skills * 100
    end
  end

  # This function helps the score() function to determin the skills tha match
  # between the ninja and the mentor.
  defp matching_skills([], _mentor_skills), do: 0

  defp matching_skills(ninja_skills, mentor_skills) do
    [skill | rest] = ninja_skills

    if Enum.member?(mentor_skills, skill) == true do
      1 + matching_skills(rest, mentor_skills)
    else
      matching_skills(rest, mentor_skills)
    end
  end

  # In order to simplify the format of the matrix that will run in the
  # Hungarian algorirthm, this function creates a matrix with just the scores
  # of the pairings table.
  defp create_matrix([]), do: []

  defp create_matrix([row | rest]) do
    [aux_create_matrix(row) | create_matrix(rest)]
  end

  defp aux_create_matrix(row) do
    Enum.map(row, fn pair -> pair.score end)
  end

  # When the Hungarian algorirthm finishes, this fucntion creates all the lectures
  # for the resulted matches.
  defp create_lectures(_pairings_table, [], _event_id), do: []

  defp create_lectures(pairings_table, [{c, r} | rest], event_id) do
    pairing =
      Enum.at(pairings_table, c)
      |> Enum.at(r)

    attrs = %{
      ninja_id: pairing.ninja.id,
      mentor_id: pairing.mentor.id,
      event_id: event_id
    }

    [Events.create_lecture(attrs) | create_lectures(pairings_table, rest, event_id)]
  end
end
