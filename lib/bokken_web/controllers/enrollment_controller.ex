defmodule BokkenWeb.EnrollmentController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Events.Enrollment

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_guardian(conn) when conn.assigns.current_user.role === :guardian
  defguard is_admin(conn) when conn.assigns.current_user.role === :admin

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

  def create(conn, %{
        "enrollment" => %{"ninja_id" => ninja_id, "accepted" => accepted} = enrollment_params
      })
      when is_guardian(conn) do
    guardian = conn.assigns.current_user.guardian

    if is_guardian_of_ninja(guardian, ninja_id) do
      if accepted do
        conn
        |> put_status(:forbidden)
        |> render("error.json", reason: "Guardian can not submit an accepted enrollment")
      else
        with {:ok, %Enrollment{} = enrollment} <- Events.create_enrollment(enrollment_params) do
          conn
          |> put_status(:created)
          |> render("show.json", enrollment: enrollment)
        end
      end
    else
      conn
      |> put_status(:forbidden)
      |> render("error.json", reason: "Not the ninja's guardian")
    end
  end

  def delete(conn, %{"id" => enrollment_id}) when is_guardian(conn) do
    enrollment = Events.get_enrollment(enrollment_id, [:ninja])
    guardian = conn.assigns.current_user.guardian

    if is_nil(enrollment) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "No such enrollment")
    else
      if is_guardian_of_ninja(guardian, enrollment.ninja.id) do
        with {:ok, %Enrollment{}} <- Events.delete_enrollment(enrollment) do
          conn
          |> put_status(:ok)
          |> render("success.json", message: "Enrollment deleted successfully")
        end
      else
        conn
        |> put_status(:unauthorized)
        |> render("error.json", reason: "Not the ninja's guardian")
      end
    end
  end

  def update(conn, %{"enrollment" => enrollment_params}) do
    old_enrollment = Events.get_enrollment(enrollment_params["id"])

    with {:ok, %Enrollment{} = new_enrollment} <-
           Events.update_enrollment(old_enrollment, enrollment_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", enrollment: new_enrollment)
    end
  end

  defp is_guardian_of_ninja(guardian, ninja_id) do
    ninja = Accounts.get_ninja!(ninja_id, [:guardian])
    ninja.guardian.id == guardian.id
  end
end
