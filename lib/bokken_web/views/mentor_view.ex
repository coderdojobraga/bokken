defmodule BokkenWeb.MentorView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.MentorView
  alias BokkenWeb.SkillJSON

  def render("index.json", %{mentors: mentors, current_user: current_user}) do
    %{data: render_many(mentors, MentorView, "mentor.json", current_user: current_user)}
  end

  def render("show.json", %{mentor: mentor, current_user: current_user}) do
    %{data: render_one(mentor, MentorView, "mentor.json", current_user: current_user)}
  end

  def render("mentor.json", %{mentor: mentor, current_user: current_user}) do
    data(mentor)
    |> Map.merge(personal(mentor, current_user))
    |> Map.merge(sensitive(mentor, current_user))
  end

  defp data(mentor) do
    %{
      id: mentor.id,
      photo: Avatar.url({mentor.photo, mentor}, :thumb),
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      socials: mentor.socials,
      since: mentor.inserted_at
    }
    |> Map.merge(skills(mentor))
  end

  defp personal(mentor, current_user)
       when current_user.role == :organizer or current_user.id == mentor.id do
    %{
      major: mentor.major,
      mobile: mentor.mobile,
      birthday: mentor.birthday
    }
  end

  defp personal(_mentor, _current_user), do: %{}

  defp sensitive(mentor, current_user)
       when current_user.role == :organizer or current_user.id == mentor.id do
    %{
      t_shirt: mentor.t_shirt,
      trial: mentor.trial
    }
  end

  defp sensitive(_mentor, _current_user), do: %{}

  defp skills(mentor) do
    if Ecto.assoc_loaded?(mentor.skills) do
      %{skills: for(skill <- mentor.skills, do: SkillJSON.data(skill))}
    else
      %{}
    end
  end
end
