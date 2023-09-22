defmodule BokkenWeb.LectureJSON do
  @moduledoc false

  alias BokkenWeb.EventJSON
  alias BokkenWeb.FileJSON
  alias BokkenWeb.MentorJSON
  alias BokkenWeb.NinjaJSON
  alias Bokken.Events.Lecture



  def index(%{lectures: lectures, current_user: current_user}) do
    %{data: for(lecture <- lectures, do: data(lecture,current_user))}
  end

  def show(%{lecture: lecture, current_user: current_user}) do
    %{data: data(lecture,current_user)}
  end

  def data(%Lecture{} = lecture, current_user) do
    %{
      id: lecture.id,
      summary: lecture.summary,
      notes: lecture.notes,
      attendance: lecture.attendance
    }
    |> Map.merge(mentor(lecture,current_user))
    |> Map.merge(ninja(lecture,current_user))
    |> Map.merge(event(lecture))
    |> Map.merge(mentor_assistants(lecture,current_user))
    |> Map.merge(files(lecture))
  end

  defp ninja(lecture, current_user) do
    if Ecto.assoc_loaded?(lecture.ninja) do
      %{ninja: NinjaJSON.data(lecture.ninja, current_user: current_user)}
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
          #render_many(lecture.assistant_mentors, MentorView, "mentor.json",current_user: current_user)
          for(mentor <- lecture.assistant_mentors, do: MentorJSON.data(mentor, current_user))
        }
    else
      %{}
    end
  end

  defp event(lecture) do
    if Ecto.assoc_loaded?(lecture.event) do
      #%{event: render_one(lecture.event, EventView, "event.json")}
      %{event: EventJSON.data(%{event: lecture.event})}
    else
      %{event_id: lecture.event_id}
    end
  end

  defp files(lecture) do
    if Ecto.assoc_loaded?(lecture.files) do
      #%{files: render_many(lecture.files, FileView, "file.json")}
      %{files: for(file <- lecture.files, do: FileJSON.data(file))}
    else
      %{}
    end
  end
end
