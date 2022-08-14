defmodule Bokken.Pairings do
  import Ecto.Query, warn: false
  
  alias Bokken.Curriculum

  def create_pairings(event_id) do
    available_mentors = get_available_mentors(event_id)
    available_ninjas = get_available_ninjas(event_id)

    match_making(available_mentors, available_ninjas, event_id)
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

  defp match_making(_available_mentors, [], _event_id), do: []
  defp match_making(available_mentors, available_ninjas, event_id) do
    [ninja | rest] = available_ninjas
    ninja_skills = Curriculum.list_ninja_skills(%{"ninja_id" => ninja.id})

    available_mentors = match_mentor(ninja, ninja_skills, available_mentors, event_id)

    lecture = match_mentor(ninja, ninja_skills, available_mentors, event_id)

    [lecture | match_making(available_mentors, rest, event_id)]  
  end

  defp match_mentor(ninja, _ninja_skills, [], event_id, selected_mentor) do
    attrs = %{
      ninja_id: ninja.user_id,
      mentor_id: selected_mentor.mentor_id,
      event_id: event_id
    }
    Events.create_lecture(attrs)
  end
  defp match_mentor(ninja, ninja_skills, available_mentors, event_id, selected_mentor \\ nil) do
    [mentor | rest] = available_mentors
    mentor_skills = Curriculum.list_mentor_skills(%{"mentor_id" => mentor.id})
    matching_skills = matching_skills(ninja_skills, mentor_skills)
    
    if selected_mentor == nil do
      selected_mentor = %{
        mentor_id: mentor.user_id,
        skills: matching_skills
      }

      match_mentor(ninja, rest, event_id, selected_mentor)
    else
      if matching_skills > selected_mentor.skills do
        selected_mentor = %{
          mentor_id: mentor.user_id,
          skills: matching_skills
        }

        match_mentor(ninja, rest, event_id, selected_mentor)

      else
        match_mentor(ninja, rest, event_id, selected_mentor)
      end
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
end
