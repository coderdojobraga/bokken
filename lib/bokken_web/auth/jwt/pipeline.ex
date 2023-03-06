defmodule BokkenWeb.Auth.JWT.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :bokken,
    module: Bokken.Authorization,
    error_handler: BokkenWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: false, halt: true
end
