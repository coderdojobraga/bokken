defmodule BokkenWeb.LectureView do
  use BokkenWeb, :view
  alias BokkenWeb.EventView
  alias BokkenWeb.FileView
  alias BokkenWeb.LectureView
  alias BokkenWeb.MentorView
  alias BokkenWeb.NinjaView

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
    |> Map.merge(mentor_assistants(lecture))
    |> Map.merge(files(lecture))
  end

  defp base(lecture) do
    %{
      id: lecture.id,
      summary: lecture.summary,
      notes: lecture.notes,
      attendance: lecture.attendance
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

  defp mentor_assistants(lecture) do
    if Ecto.assoc_loaded?(lecture.assistant_mentors) do
      %{assistant_mentors: render_many(lecture.assistant_mentors, MentorView, "mentor.json")}
    else
      %{}
    end
  end

  defp event(lecture) do
    if Ecto.assoc_loaded?(lecture.event) do
      %{event: render_one(lecture.event, EventView, "event.json")}
    else
      %{event_id: lecture.event_id}
    end
  end

  defp files(lecture) do
    if Ecto.assoc_loaded?(lecture.files) do
      %{files: render_many(lecture.files, FileView, "file.json")}
    else
      %{}
    end
  end
end
