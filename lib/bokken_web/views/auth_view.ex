defmodule BokkenWeb.AuthView do
  use BokkenWeb, :view
  alias BokkenWeb.AuthView
  alias BokkenWeb.GuardianView
  alias BokkenWeb.MentorView

  def render("token.json", %{jwt: token}) do
    %{
      jwt: token
    }
  end

  def render("me.json", %{user: %{active: false} = user}) do
    render_one(user, AuthView, "user.json")
  end

  def render("me.json", %{user: %{role: :mentor, mentor: mentor} = user}) do
    render_one(mentor, MentorView, "mentor.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:mentor_id, mentor.id)
  end

  def render("me.json", %{user: %{role: :guardian, guardian: guardian} = user}) do
    render_one(guardian, GuardianView, "guardian.json")
    |> Map.merge(render_one(user, AuthView, "user.json"))
    |> Map.put(:guardian_id, guardian.id)
  end

  def render("user.json", %{auth: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified
    }
  end

  def render("mentor.json", %{mentor: mentor}) do
    render_one(mentor, MentorView, "mentor.json")
  end

  def render("guardian.json", %{guardian: guardian}) do
    render_one(guardian, GuardianView, "guardian.json")
  end
end
