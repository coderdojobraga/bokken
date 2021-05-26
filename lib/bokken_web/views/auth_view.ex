defmodule BokkenWeb.AuthView do
  use BokkenWeb, :view
  alias BokkenWeb.AuthView
  alias BokkenWeb.GuardianView
  alias BokkenWeb.MentorView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.OrganizerView

  def render("me.json", %{user: %{active: false} = user}) do
    render_one(user, AuthView, "user.json")
  end

  def render("me.json", %{user: %{role: :guardian, guardian: guardian} = user}) do
    render_one(guardian, GuardianView, "guardian.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:guardian_id, guardian.id)
  end

  def render("me.json", %{user: %{role: :mentor, mentor: mentor} = user}) do
    render_one(mentor, MentorView, "mentor.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:mentor_id, mentor.id)
  end

  def render("me.json", %{user: %{role: :ninja, ninja: ninja} = user}) do
    render_one(ninja, NinjaView, "ninja.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:ninja_id, ninja.id)
  end

  def render("me.json", %{user: %{role: :organizer, organizer: organizer} = user}) do
    render_one(organizer, OrganizerView, "organizer.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:organizer_id, organizer.id)
  end

  def render("user.json", %{auth: user}) do
    registered =
      [user.mentor, user.guardian, user.ninja, user.organizer]
      |> Enum.any?(&Ecto.assoc_loaded?(&1))

    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified,
      registered: registered
    }
  end
end
