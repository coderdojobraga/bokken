defmodule BokkenWeb.EnrollmentController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
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
          "enrollment" =>
            %{"ninja_id" => ninja_id, "accepted" => accepted, "event_id" => event_id} =
              enrollment_params
        }
      )
      when is_guardian(conn) do
    guardian = conn.assigns.current_user.guardian
    event = Events.get_event!(event_id)

    cond do
      # credo:disable-for-next-line Credo.Check.Design.TagTODO
      # TODO verify guardian inside the Events.create_enrollment function
      !is_guardian_of_ninja(guardian, ninja_id) ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", reason: "Not the ninja's guardian")

      # credo:disable-for-next-line Credo.Check.Design.TagTODO
      # TODO create a create_enrollement_changeset for guardians and one for admins
      accepted ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", reason: "Guardian cannot submit an accepted enrollment")

      true ->
        with {:ok, %Enrollment{} = enrollment} <-
               Events.create_enrollment(event, enrollment_params) do
          conn
          |> put_status(:created)
          |> render("show.json", enrollment: enrollment)
        end
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

  def update(conn, %{"enrollment" => enrollment_params}) when is_organizer(conn) do
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
