defmodule BokkenWeb.EnrollmentController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Events
  alias Bokken.Events.Enrollment

  action_fallback BokkenWeb.FallbackController

  def show(conn, %{"id" => enrollment_id}) do
    enrollment = Events.get_enrollment(enrollment_id)

    if is_nil(enrollment) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "No such enrollment")
    else
      conn
      |> put_status(:ok)
      |> render("show.json", enrollment: enrollment)
    end
  end

  def index(conn, %{"ninja_id" => _ninja_id} = params) do
    enrollments = Events.list_enrollments(params)

    conn
    |> put_status(:ok)
    |> render("index.json", enrollments: enrollments)
  end

  def index(conn, %{"event_id" => _event_id} = params) do
    enrollments = Events.list_enrollments(params)

    conn
    |> put_status(:ok)
    |> render("index.json", enrollments: enrollments)
  end

  def create(
        conn,
        %{
          "enrollment" => %{"ninja_id" => ninja_id, "event_id" => event_id} = enrollment_params
        }
      )
      when is_guardian(conn) do
    guardian = conn.assigns.current_user.guardian
    event = Events.get_event!(event_id)

    with {:ok, enrollment} <-
           Events.guardian_create_enrollment(event, guardian.id, ninja_id, enrollment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", enrollment: enrollment)
    end
  end

  def delete(conn, %{"id" => enrollment_id}) when is_guardian(conn) do
    enrollment = Events.get_enrollment(enrollment_id, [:ninja])
    guardian = conn.assigns.current_user.guardian
    ninja = enrollment.ninja

    if is_nil(enrollment) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "No such enrollment")
    else
      with {:ok, %Enrollment{}} <-
             Events.guardian_delete_enrollment(enrollment, guardian.id, ninja.id) do
        conn
        |> put_status(:ok)
        |> render("success.json", message: "Enrollment deleted successfully")
      end
    end
  end

  def update(conn, %{"enrollment" => enrollment_params}) when is_organizer(conn) do
    old_enrollment = Events.get_enrollment(enrollment_params["id"])

    with {:ok, %Enrollment{} = new_enrollment} <-
           Events.update_enrollment(old_enrollment, enrollment_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", enrollment: new_enrollment)
    end
  end
end
