defmodule Bokken.Pairings do
  import Ecto.Query, warn: false
  
  alias Bokken.{Curriculum, Repo, HungarianAlgorithm, Events}

  def create_pairings(event_id) do
    available_mentors = get_available_mentors(event_id)
    available_ninjas = get_available_ninjas(event_id)
    
    pairings_table = pairings_table(available_ninjas, available_mentors)

    matches = create_matrix(pairings_table)
               |> HungarianAlgorithm.compute()
    
    create_lectures(pairings_table, matches, event_id)
  end
  
  def get_available_mentors(event_id) do
    query = from availability in Bokken.Events.Availability, where: 
      availability.is_available? == true and
      availability.event_id == ^event_id
    Repo.all(query)
  end

  def get_available_ninjas(event_id) do
    query = from enrollment in Bokken.Events.Enrollment, where: 
      enrollment.event_id == ^event_id and
      enrollment.accepted == true

    Repo.all(from q in query, order_by: q.inserted_at)
  end

  defp pairings_table([], _rest_mentors), do: []
  defp pairings_table([ninja | rest_ninjas], mentors) do
    row = Enum.map(mentors, fn(mentor) -> 
      %{ninja: ninja, mentor: mentor, score: 100 - score(ninja.skills, mentor.skills)} 
    end)

    [row | pairings_table(rest_ninjas, mentors)]
  end

  defp score(ninja_skills, mentor_skills) do
    matching_skills = matching_skills(ninja_skills, mentor_skills)
    
    total_skills = Enum.concat(ninja_skills, mentor_skills)
                   |> Enum.frequencies
                   |> Enum.count

    if matching_skills == 0 do
      0
    else
      (matching_skills / total_skills) * 100
    end
  end

  defp matching_skills([], _mentor_skills), do: 0
  defp matching_skills(ninja_skills, mentor_skills) do
    [skill | rest] = ninja_skills

    if Enum.member?(mentor_skills, skill) == true do
      1 + matching_skills(rest, mentor_skills)
    else
      matching_skills(rest, mentor_skills)
    end
  end


  defp create_matrix([]), do: []
  defp create_matrix([row | _rest]) do
    Enum.map(row, fn pair -> pair.score end)
  end

  defp create_lectures(_pairings_table, [], _event_id), do: []
  defp create_lectures(pairings_table, [{c, r} | rest], event_id) do
    pairing = Enum.at(pairings_table, c)
              |> Enum.at(r)
    
    attrs = %{
      ninja_id: pairing.ninja.id,
      mentor_id: pairing.mentor.id,
      event_id: event_id
    }

    [Events.create_lecture(attrs) | create_lectures(pairings_table, rest, event_id)]
  end
end
