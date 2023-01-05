defmodule BokkenWeb.AdminView do
  use BokkenWeb, :view

  alias BokkenWeb.AdminView
  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.AuthView

  def render("index.json", %{mentors: mentors}) do
    %{data: render_many(mentors, AdminView, "mentor.json", as: :mentor)}
  end

  def render("mentor.json", %{mentor: mentor}) do
    %{
      id: mentor.id,
      photo: Avatar.url({mentor.photo, mentor}, :thumb),
      first_name: mentor.first_name,
      last_name: mentor.last_name,
      mobile: mentor.mobile,
      birthday: mentor.birthday,
      trial: mentor.trial,
      major: mentor.major,
      socials: mentor.socials,
      since: mentor.inserted_at
    }
    |> Map.merge(user(mentor))
  end

  defp user(mentor) do
    if Ecto.assoc_loaded?(mentor.user) do
      render_one(mentor.user, AuthView, "user.json")
      |> then(
        &Map.new(&1, fn
          {:id, value} -> {:user_id, value}
          pair -> pair
        end)
      )
    else
      %{}
    end
  end
end
