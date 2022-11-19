defmodule Bokken.Guards do
  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_guardian(conn) when conn.assigns.current_user.role === :guardian
  defguard is_registered(conn) when conn.assigns.current_user.registered

  defguard is_404(reason) when reason in [:not_found, :not_registered, :invalid_credentials]
  defguard is_401(reason) when reason in [:token_expired]
end
