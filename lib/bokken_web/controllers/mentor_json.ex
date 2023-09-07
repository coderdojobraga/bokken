defmodule BokkenWeb.MentorJSON do
  alias Bokken.Accounts.Mentor

  alias Bokken.Uploaders.Avatar

  alias BokkenWeb.SkillJSON

  def index(%{mentors: mentors, current_user: current_user}) do
    %{data: for(mentor <- mentors, do: data(mentor, current_user))}
  end

  def show(%{mentor: mentor, current_user: current_user}) do
    %{data: data(mentor, current_user)}
  end

  def data(%Mentor{} = mentor, current_user) do
    %{
      id: mentor.id,
      photo: Avatar.url({mentor.photo, mentor}, :thumb),
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      socials: mentor.socials,
      since: mentor.inserted_at
    }
    |> Map.merge(maybe_put_attendance(mentor))
    |> Map.merge(personal(mentor, current_user))
    |> Map.merge(sensitive(mentor, current_user))
    |> Map.merge(skills(mentor))
  end

  defp maybe_put_attendance(mentor) do
    if Map.has_key?(mentor, :attendance) do
      %{attendance: mentor.attendance}
    else
      %{}
    end
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
