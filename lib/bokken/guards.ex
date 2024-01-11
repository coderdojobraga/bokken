defmodule Bokken.Guards do
  @moduledoc """
  A module to handle guards used on the whole project.
  """

  @doc """
  Defines the different types of Guards.

  ## Examples

      defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer
      Means to return True when an organizer is logged.

  """
  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_guardian(conn) when conn.assigns.current_user.role === :guardian
  defguard is_registered(conn) when conn.assigns.current_user.registered

  @doc """
  Defines the way to proceed in specific roles situations.

  ## Examples

      defguard is_ninja_guardian(user, ninja) when user.role == :guardian and user.guardian.id == ninja.guardian.id
      Means to return True when a user is the ninja's guardian.

  """
  defguard is_ninja_guardian(user, ninja)
           when user.role == :guardian and user.guardian.id == ninja.guardian.id

  defguard is_ninja_user(user, ninja) when user.role == :ninja and user.id == ninja.user_id

  @doc """
  Defines the way to proceed in specific error situations.

  ## Examples

      defguard is_401(reason) when reason in [:token_expired]
      Means to return True when a token has expired.

  """
  defguard is_404(reason) when reason in [:not_found, :not_registered, :invalid_credentials]
  defguard is_401(reason) when reason in [:not_authorized, :token_expired]

  defguard is_403(reason)
           when reason in [
                  :already_enrolled,
                  :enrollments_closed
                ]
end
