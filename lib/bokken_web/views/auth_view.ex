defmodule BokkenWeb.AuthView do
  use BokkenWeb, :view
  alias BokkenWeb.AuthView
  alias BokkenWeb.GuardianView
  alias BokkenWeb.MentorView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.OrganizerView

  def render("me.json", %{user: user, registered: false}) do
    render_one(user, AuthView, "unregistered.json")
  end

  def render("me.json", %{user: %{role: :guardian, guardian: guardian} = user}) do
    render_one(guardian, GuardianView, "guardian.json")
    |> Map.merge(render_one(user, AuthView, "registered.json"))
    |> Map.put(:guardian_id, guardian.id)
  end

  def render("me.json", %{user: %{role: :mentor, mentor: mentor} = user}) do
    render_one(mentor, MentorView, "mentor.json")
    |> Map.merge(render_one(user, AuthView, "registered.json"))
    |> Map.put(:mentor_id, mentor.id)
  end

  def render("me.json", %{user: %{role: :ninja, ninja: ninja} = user}) do
    render_one(ninja, NinjaView, "ninja.json")
    |> Map.merge(render_one(user, AuthView, "registered.json"))
    |> Map.put(:ninja_id, ninja.id)
  end

  def render("me.json", %{user: %{role: :organizer, organizer: organizer} = user}) do
    render_one(organizer, OrganizerView, "organizer.json")
    |> Map.merge(render_one(user, AuthView, "registered.json"))
    |> Map.put(:organizer_id, organizer.id)
  end

  def render("registered.json", %{auth: user}) do
    base(user)
    |> Map.merge(%{registered: true})
  end

  def render("unregistered.json", %{auth: user}) do
    base(user)
    |> Map.merge(%{registered: false})
  end

  defp base(user) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified
    }
  end
end
