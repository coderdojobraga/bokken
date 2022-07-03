defmodule BokkenWeb.EnrollmentController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Enrollment

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_guardian(conn) when conn.assigns.current_user.role === :guardian
  defguard is_admin(conn) when conn.assigns.current_user.role === :admin

  def get(conn, %{"enrollment_id" => enrollment_id}) when is_guardian(conn) or is_admin(conn) do
    enrollment = Events.get_enrollment!(enrollment_id)

    if is_guardian(conn) and enrollment.ninja not in conn.assigns.current_user.ninjas do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "Not found")
    else
      conn
      |> put_status(:success)
      |> render("show.json", enrollment: enrollment)
    end
  end

  def get(conn, %{"ninja_id" => ninja_id} = params) when is_guardian(conn) or is_admin(conn) do
    if is_guardian(conn) and
         ninja_id not in Enum.map(conn.assigns.current_user.ninjas, fn x -> x["id"] end) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "Not found")
    else
      enrollments = Events.list_enrollments(params)

      conn
      |> put_status(:success)
      |> render("index.json", enrollments: enrollments)
    end
  end

  def get(conn, %{"event_id" => _event_id} = params) when is_admin(conn) do
    enrollments = Events.list_enrollments(params)

    conn
    |> put_status(:success)
    |> render("index.json", enrollments: enrollments)
  end

  def create(conn, %{"enrollment" => enrollment_params}) when is_guardian(conn) do
    guardian = conn.assigns.current_user.guardian

    if enrollment_params.ninja_id in guardian.ninjas do
      with {:ok, %Enrollment{} = enrollment} <- Events.create_enrollment(enrollment_params) do
        conn
        |> put_status(:created)
        |> render("show.json", enrollment: enrollment)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "Not the ninja's guardian")
    end
  end

  def delete(conn, %{"enrollment_id" => enrollment_id}) when is_guardian(conn) do
    enrollment = Events.get_enrollment!(enrollment_id)
    guardian = conn.assigns.current_user.guardian

    if is_nil(enrollment) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "No such enrollment")
    else
      if enrollment.ninja in guardian.ninjas do
        with {:ok, %Enrollment{}} <- Events.delete_enrollment(enrollment) do
          conn
          |> put_status(:deleted)
          |> render("success.json", message: "Enrollment deleted successfully")
        end
      else
        conn
        |> put_status(:unauthorized)
        |> render("error.json", reason: "Not the ninja's guardian")
      end
    end
  end

  def update(conn, %{"enrollment" => enrollment_params}) when is_admin(conn) do
    old_enrollment = Events.get_enrollment!(enrollment_params.id)

    with {:ok, %Enrollment{} = new_enrollment} <-
           Events.update_enrollment(old_enrollment, enrollment_params) do
      conn
      |> put_status(:updated)
      |> render("show.json", enrollment: new_enrollment)
    end
  end
end
