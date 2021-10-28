defmodule BokkenWeb.Auth.Pipeline do
  @moduledoc """
  By using a pipeline, apart from keeping your authentication logic together,
  you're instructing downstream plugs to use a particular implementation
  module and error handler.
  """
  use Guardian.Plug.Pipeline,
    otp_app: :bokken,
    module: BokkenWeb.Authorization,
    error_handler: BokkenWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource

  plug BokkenWeb.Auth.CurrentUser
end
