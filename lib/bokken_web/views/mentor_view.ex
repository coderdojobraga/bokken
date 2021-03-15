defmodule BokkenWeb.MentorView do
  use BokkenWeb, :view
  alias BokkenWeb.MentorView

  def render("index.json", %{mentors: mentors}) do
    %{data: render_many(mentors, MentorView, "mentor.json")}
  end

  def render("show.json", %{mentor: mentor}) do
    %{data: render_one(mentor, MentorView, "mentor.json")}
  end

  def render("mentor.json", %{mentor: mentor}) do
    %{
      id: mentor.id,
      photo: mentor.photo,
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      mobile: mentor.mobile,
      birthday: mentor.birthday,
      trial: mentor.trial,
      major: mentor.major,
      socials: mentor.socials
    }
  end
end
