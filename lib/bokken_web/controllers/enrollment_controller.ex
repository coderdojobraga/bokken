defmodule BokkenWeb.EventController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Enrollment

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_guardian(conn) when conn.assigns.current_user.role === :guardian
  defguard is_admin(conn) when conn.assigns.current_user.role === :admin

  #TODO:: Return 401 if not authorized
  def create(conn, %{"enrollment" => enrollment_params}) do
    cond do
      is_guardian(conn) ->
        guardian = conn.assigns.current_user.guardian
        if enrollment_params.ninja_id in guardian.ninjas do
          with {:ok, %Enrollment{} = enrollment} <- Events.create_enrollment(enrollment_params) do
            conn
            |> put_status(:created)
            |> render("show.json", enrollment: enrollment)
          end
        end
    end
  end
end
