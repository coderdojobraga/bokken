defmodule BokkenWeb.LectureView do
  use BokkenWeb, :view

  alias BokkenWeb.EventJSON
  alias BokkenWeb.FileJSON
  alias BokkenWeb.LectureView
  alias BokkenWeb.MentorJSON
  alias BokkenWeb.NinjaView

  def render("index.json", %{lectures: lectures, current_user: current_user}) do
    %{data: render_many(lectures, LectureView, "lecture.json", current_user: current_user)}
  end

  def render("show.json", %{lecture: lecture, current_user: current_user}) do
    %{data: render_one(lecture, LectureView, "lecture.json", current_user: current_user)}
  end

  def render("lecture.json", %{lecture: lecture, current_user: current_user}) do
    base(lecture)
    |> Map.merge(ninja(lecture, current_user))
    |> Map.merge(mentor(lecture, current_user))
    |> Map.merge(event(lecture))
    |> Map.merge(mentor_assistants(lecture, current_user))
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

  defp ninja(lecture, current_user) do
    if Ecto.assoc_loaded?(lecture.ninja) do
      %{ninja: render_one(lecture.ninja, NinjaView, "ninja.json", current_user: current_user)}
    else
      %{ninja_id: lecture.ninja_id}
    end
  end

  defp mentor(lecture, current_user) do
    if Ecto.assoc_loaded?(lecture.mentor) do
      %{mentor: MentorJSON.data(lecture.mentor, current_user)}
    else
      %{mentor_id: lecture.mentor_id}
    end
  end

  defp mentor_assistants(lecture, current_user) do
    if Ecto.assoc_loaded?(lecture.assistant_mentors) do
      %{
        assitant_mentors:
          for(mentor <- lecture.assistant_mentors, do: MentorJSON.data(mentor, current_user))
      }
    else
      %{}
    end
  end

  defp event(lecture) do
    if Ecto.assoc_loaded?(lecture.event) do
      %{event: EventJSON.data(lecture.event)}
    else
      %{event_id: lecture.event_id}
    end
  end

  defp files(lecture) do
    if Ecto.assoc_loaded?(lecture.files) do
      %{files: for(file <- lecture.files, do: FileJSON.data(file))}
    else
      %{}
    end
  end
end
