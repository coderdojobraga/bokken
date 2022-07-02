defmodule BokkenWeb.EnrollmentView do
  use BokkenWeb, :view
  alias BokkenWeb.EventView
  alias BokkenWeb.EnrollmentView
  alias BokkenWeb.NinjaView

  def render("index.json", %{enrollments: enrollments}) do
    %{data: render_many(enrollments, EnrollmentView, "enrollment.json")}
  end

  def render("show.json", %{enrollment: enrollment}) do
    %{data: render_one(enrollment, EnrollmentView, "event.json")}
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("enrollment.json", %{enrollment: enrollment}) do
    base(enrollment)
    |> Map.merge(event(enrollment))
    |> Map.merge(ninja(enrollment))
  end

  defp base(enrollment) do
    %{
      id: enrollment.id,
      accepted: enrollment.title,
    }
  end

  defp ninja(enrollment) do
    if Ecto.assoc_loaded?(enrollment.ninja) do
      %{ninja: render_one(enrollment.ninja, NinjaView, "ninja.json")}
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
