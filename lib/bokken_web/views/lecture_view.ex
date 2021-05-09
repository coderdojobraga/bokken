defmodule BokkenWeb.LectureView do
  use BokkenWeb, :view
  alias BokkenWeb.LectureView
  alias BokkenWeb.EventView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.MentorView

  def render("index.json", %{lectures: lectures}) do
    %{data: render_many(lectures, LectureView, "lecture.json")}
  end

  def render("show.json", %{lecture: lecture}) do
    %{data: render_one(lecture, LectureView, "lecture.json")}
  end

  def render("lecture.json", %{lecture: lecture}) do
    base(lecture)
    |> Map.merge(ninja(lecture))
    |> Map.merge(mentor(lecture))
    |> Map.merge(event(lecture))
    |> Map.merge(mentor_assistant(lecture))
  end

  defp base(lecture) do
    %{
      id: lecture.id,
      summary: lecture.summary,
      notes: lecture.notes
    }
  end

  defp ninja(lecture) do
    if Ecto.assoc_loaded?(lecture.ninja) do
      %{ninja: render_one(lecture.ninja, NinjaView, "ninja.json")}
    else
      %{ninja_id: lecture.ninja_id}
    end
  end

  defp mentor(lecture) do
    if Ecto.assoc_loaded?(lecture.mentor) do
      %{mentor: render_one(lecture.mentor, MentorView, "mentor.json")}
    else
      %{mentor_id: lecture.mentor_id}
    end
  end

  defp mentor_assistant(lecture) do
    if Ecto.assoc_loaded?(lecture.assistant_mentor) do
      %{assistant_mentor: render_many(lecture.assistant_mentor, MentorView, "mentor.json")}
    else
      %{assistant_mentor_id: lecture.mentor_id}
    end
  end

  defp event(lecture) do
    if Ecto.assoc_loaded?(lecture.event) do
      %{event: render_one(lecture.event, EventView, "event.json")}
    else
      %{event_id: lecture.event_id}
    end
  end
end
