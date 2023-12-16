defmodule BokkenWeb.EnrollmentView do
  use BokkenWeb, :view

  alias BokkenWeb.EnrollmentView
  alias BokkenWeb.EventView
  alias BokkenWeb.NinjaJSON

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
      %{ninja: NinjaJSON.show(%{ninja: enrollment.ninja, current_user: current_user})}
    else
      %{ninja_id: enrollment.ninja_id}
    end
  end

  defp event(enrollment) do
    if Ecto.assoc_loaded?(enrollment.event) do
      %{event: render_one(enrollment.event, EventView, "event.json")}
    else
      %{event_id: enrollment.event_id}
    end
  end
end
