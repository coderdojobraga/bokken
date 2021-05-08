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
    %{id: lecture.id, summary: lecture.summary, notes: lecture.notes}
  end
end
