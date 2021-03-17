defmodule BokkenWeb.Router do
  use BokkenWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug BokkenWeb.Auth.Pipeline
  end

  scope "/", BokkenWeb do
    get "/", PageController, :index
  end

  scope "/api", BokkenWeb do
    pipe_through :api

    scope "/auth" do
      post "/sign_up", AuthController, :sign_up
      post "/sign_in", AuthController, :sign_in

      pipe_through :authenticated

      get "/me", AuthController, :show
    end

    pipe_through :authenticated

    resources "/guardians", GuardianController, except: [:new, :edit]
    resources "/guardians", GuardianController, except: [:new, :edit]
    resources "/mentors", MentorController, except: [:new, :edit]
    resources "/ninjas", NinjaController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BokkenWeb.Telemetry, ecto_repos: [Bokken.Repo]
    end
  end
end
