defmodule BokkenWeb.MentorJSON do

  alias Bokken.Accounts.Mentor

  def index(%{mentors: mentors,current_user: current_user}) do
    %{data: for(mentor <- mentors, do: data(mentor,current_user))}
  end

  def show(%{mentor: mentor,current_user: current_user}) do
    %{data: data(mentor,current_user)}
  end

  def data(%Mentor{} = mentor,_) do
    %{
      id: mentor.id,
      photo: mentor.photo,
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      mobile: mentor.mobile,
      birthday: mentor.birthday,
      major: mentor.major,
      t_shirt: mentor.t_shirt,
      trial: mentor.trial,
      skills: mentor.skills,
      lectures: mentor.lectures,
      teams: mentor.teams,
      user_id: mentor.user_id,

    }
  end
end
