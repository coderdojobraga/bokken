defmodule BokkenWeb.LectureView do
  use BokkenWeb, :view
  alias BokkenWeb.LectureView

  def render("index.json", %{lectures: lectures}) do
    %{data: render_many(lectures, LectureView, "lecture.json")}
  end

  def render("show.json", %{lecture: lecture}) do
    %{data: render_one(lecture, LectureView, "lecture.json")}
  end

  def render("lecture.json", %{lecture: lecture}) do
    %{
      id: lecture.id,
      summary: lecture.summary,
      notes: lecture.notes,
      mentor_id: lecture.mentor_id,
      ninja_id: lecture.ninja_id,
      event_id: lecture.event_id,
      assistants_mentors: lecture.assistants_mentors
    }
  end
end
