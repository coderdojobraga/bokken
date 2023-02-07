defmodule BokkenWeb.AdminView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.AdminView
  alias BokkenWeb.AuthView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, AdminView, "user.json", as: :user)}
  end

  def render("index.json", %{mentors: mentors}) do
    %{data: render_many(mentors, AdminView, "mentor.json", as: :mentor)}
  end

  def render("index.json", %{ninjas: ninjas}) do
    %{data: render_many(ninjas, AdminView, "ninja.json", as: :ninja)}
  end

  def render("index.json", %{guardians: guardians}) do
    %{data: render_many(guardians, AdminView, "guardian.json", as: :guardian)}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified,
      registered: user.registered,
      since: user.inserted_at
    }
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
    |> Map.merge(user(mentor, :mentor))
  end

  def render("ninja.json", %{ninja: ninja}) do
    %{
      id: ninja.id,
      photo: Avatar.url({ninja.photo, ninja}, :thumb),
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      birthday: ninja.birthday,
      socials: ninja.socials,
      since: ninja.inserted_at,
      active: ninja.user.active,
      verified: ninja.user.verified,
      registered: ninja.user.registered
    }
    |> Map.merge(user(ninja, :ninja))
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
    |> Map.merge(user(guardian, :guardian))
  end

  defp user(struct, role) do
    if Ecto.assoc_loaded?(struct.user) do
      # If the user is a ninja, we simply don't want to render the user email
      if role == :ninja do
        %{
          id: struct.user.id,
          active: struct.user.active,
          verified: struct.user.verified,
          registered: struct.user.registered
        }
        |> merge_user_safe()
      else
        render_one(struct.user, AuthView, "user.json")
        |> merge_user_safe()
      end
    else
      %{}
    end
  end

  # Renames the user_id key to id to prevent conflicts before merging
  defp merge_user_safe(struct) do
    struct
    |> then(
      &Map.new(&1, fn
        {:id, value} -> {:user_id, value}
        pair -> pair
      end)
    )
  end
end
