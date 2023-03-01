defmodule BokkenWeb.Admin.MentorView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar

  def render("index.json", %{mentors: mentors}) do
    %{data: render_many(mentors, __MODULE__, "mentor.json")}
  end

  def render("mentor.json", %{mentor: mentor}) do
    %{
      id: mentor.id,
      photo: Avatar.url({mentor.photo, mentor}, :thumb),
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      mobile: mentor.mobile,
      birthday: mentor.birthday,
      major: mentor.major,
      socials: mentor.socials,
      since: mentor.inserted_at
    }
    |> Map.merge(user_attrs(mentor))
  end

  defp user_attrs(mentor) do
    if Ecto.assoc_loaded?(mentor.user) do
      %{
        user_id: mentor.user.id,
        email: mentor.user.email,
        active: mentor.user.active,
        verified: mentor.user.verified,
        registered: mentor.user.registered
      }
    else
      %{}
    end
  end
end
