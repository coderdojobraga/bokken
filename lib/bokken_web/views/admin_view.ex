defmodule BokkenWeb.AdminView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.AuthView

  def render("index.json", %{mentors: mentors}) do
    %{data: render_many(mentors, AdminView, "mentor.json", as: :mentor)}
  end

  def render("index.json", %{ninjas: ninjas}) do
    %{data: render_many(ninjas, AdminView, "ninja.json", as: :ninja)}
  end

  def render("index.json", %{guardians: guardians}) do
    %{data: render_many(guardians, AdminView, "guardian.json", as: :guardian)}
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

  def render("ninja.json", %{ninja: ninja}) do
    %{
      id: ninja.id,
      photo: Avatar.url({ninja.photo, ninja}, :thumb),
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      birthday: ninja.birthday,
      socials: ninja.socials,
      since: ninja.inserted_at
    }
    |> Map.merge(user(ninja))
  end

  def render("guardian.json", %{guardian: guardian}) do
    %{
      id: guardian.id,
      photo: Avatar.url({guardian.photo, guardian}, :thumb),
      first_name: guardian.first_name,
      last_name: guardian.last_name,
      mobile: guardian.mobile,
      city: guardian.city,
      since: guardian.inserted_at
    }
    |> Map.merge(user(guardian))
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
