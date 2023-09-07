defmodule BokkenWeb.EnrollmentView do
  use BokkenWeb, :view

  alias BokkenWeb.EnrollmentView
  alias BokkenWeb.EventJSON
  alias BokkenWeb.NinjaView

  def render("index.json", %{enrollments: enrollments, current_user: current_user}) do
    %{
      data:
        render_many(enrollments, EnrollmentView, "enrollment.json", current_user: current_user)
    }
  end

  def render("show.json", %{enrollment: enrollment, current_user: current_user}) do
    %{data: render_one(enrollment, EnrollmentView, "enrollment.json", current_user: current_user)}
  end

  def render("success.json", %{message: message}) do
    %{message: message}
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("enrollment.json", %{enrollment: enrollment, current_user: current_user}) do
    base(enrollment)
    |> Map.merge(event(enrollment))
    |> Map.merge(ninja(enrollment, current_user))
  end

  defp base(enrollment) do
    %{
      id: enrollment.id,
      accepted: enrollment.accepted
    }
  end

  defp ninja(enrollment, current_user) do
    if Ecto.assoc_loaded?(enrollment.ninja) do
      %{ninja: render_one(enrollment.ninja, NinjaView, "ninja.json", current_user: current_user)}
    else
      %{ninja_id: enrollment.ninja_id}
    end
  end

  defp event(enrollment) do
    if Ecto.assoc_loaded?(enrollment.event) do
      %{event: EventJSON.data(enrollment.event)}
    else
      %{event_id: enrollment.event_id}
    end
  end
end
