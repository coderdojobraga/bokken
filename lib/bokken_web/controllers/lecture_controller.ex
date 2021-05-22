defmodule BokkenWeb.LectureController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Lecture

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    lectures = Events.list_lectures()
    render(conn, "index.json", lectures: lectures)
  end

  def create(conn, %{"lecture" => params}) when is_map_key(params, "assistant_mentors") do
    with {:ok, %Lecture{} = lecture} <- Events.create_lecture_assistant(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.lecture_path(conn, :show, lecture))
      |> render("show.json", lecture: lecture)
    end
  end

  def create(conn, %{"lecture" => lecture_params}) do
    with {:ok, %Lecture{} = lecture} <- Events.create_lecture(lecture_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.lecture_path(conn, :show, lecture))
      |> render("show.json", lecture: lecture)
    end
  end

  def show(conn, %{"id" => id}) do
    lecture = Events.get_lecture!(id)
    render(conn, "show.json", lecture: lecture)
  end

  def update(conn, %{"id" => id, "lecture" => lecture_params}) do
    lecture = Events.get_lecture!(id)

    with {:ok, %Lecture{} = lecture} <- Events.update_lecture(lecture, lecture_params) do
      render(conn, "show.json", lecture: lecture)
    end
  end

  def delete(conn, %{"id" => id}) do
    lecture = Events.get_lecture!(id)

    with {:ok, %Lecture{}} <- Events.delete_lecture(lecture) do
      send_resp(conn, :no_content, "")
    end
  end
end
