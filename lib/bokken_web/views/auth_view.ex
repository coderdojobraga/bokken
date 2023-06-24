defmodule BokkenWeb.AuthView do
  use BokkenWeb, :view

  alias BokkenWeb.AuthView
  alias BokkenWeb.GuardianView
  alias BokkenWeb.MentorView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.OrganizerView

  def render("me.json", %{user: %{registered: false} = user}) do
    render_one(user, AuthView, "user.json")
  end

  def render("me.json", %{user: %{role: :guardian, guardian: guardian} = user}) do
    render_one(guardian, GuardianView, "guardian.json", current_user: user)
    |> Map.merge(render_one(user, AuthView, "user.json", current_user: user))
    |> Map.put(:guardian_id, guardian.id)
  end

  def render("me.json", %{user: %{role: :mentor, mentor: mentor} = user}) do
    render_one(mentor, MentorView, "mentor.json", current_user: user)
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:mentor_id, mentor.id)
  end

  def render("me.json", %{user: %{role: :ninja, ninja: ninja} = user}) do
    render_one(ninja, NinjaView, "ninja.json", current_user: user)
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:ninja_id, ninja.id)
  end

  def render("me.json", %{user: %{role: :organizer, organizer: organizer} = user}) do
    render_one(organizer, OrganizerView, "organizer.json")
    |> Map.merge(render_one(user, AuthView, "user.json", current_user: user))
    |> Map.put(:organizer_id, organizer.id)
  end

  def render("user.json", %{auth: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified,
      registered: user.registered
    }
  end
end
