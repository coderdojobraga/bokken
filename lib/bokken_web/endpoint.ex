defmodule BokkenWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bokken

  @app :bokken

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    secure: true,
    extra: "SameSite=None",
    key: "_bokken_key",
    signing_salt: "82k4BOy+"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Corsica,
    allow_headers: :all,
    allow_credentials: true,
    origins: {__MODULE__, :check_corsica_origin}

  def check_corsica_origin(origin) do
    regex = Application.fetch_env!(@app, BokkenWeb.Endpoint)[:allowed_origins]
    Regex.match?(regex, origin)
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: @app,
    gzip: false,
    only: ~w(images favicon.ico dojo.html robots.txt)

  plug Plug.Static,
    at: "/kaffy",
    from: :kaffy,
    gzip: false,
    only: ~w(assets)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: @app
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BokkenWeb.Router
end
