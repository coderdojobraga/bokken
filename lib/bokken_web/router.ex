defmodule BokkenWeb.Router do
  use BokkenWeb, :router

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug BokkenWeb.Auth.Pipeline
  end

  scope "/", BokkenWeb do
    get "/", PageController, :index
    get "/humans.txt", FileController, :humans_txt

    pipe_through [:fetch_session]
    pipe_through :authenticated

    get "/uploads/avatars/:user_id/:file", FileController, :avatars
  end

  scope "/api", BokkenWeb do
    pipe_through :api

    scope "/auth" do
      post "/sign_up", AuthController, :sign_up
      post "/sign_in", AuthController, :sign_in

      pipe_through :authenticated

      get "/me", AuthController, :show
      delete "/sign_out", AuthController, :sign_out
    end

    pipe_through :authenticated

    resources "/guardians", GuardianController, except: [:new, :edit]

    resources "/mentors", MentorController, except: [:new, :edit] do
      get "/teams", TeamController, :index
    end

    resources "/organizers", OrganizerController, except: [:new, :edit]

    resources "/ninjas", NinjaController, except: [:new, :edit] do
      resources "/badges", BadgeController, only: [:index, :create, :delete]
      get "/teams", TeamController, :index
    end

    resources "/badges", BadgeController, except: [:new, :edit]

    resources "/teams", TeamController, except: [:new, :edit] do
      resources "/ninjas", NinjaController, only: [:index, :create, :delete]
      resources "/mentors", MentorController, only: [:index, :create, :delete]
      get "/events", EventController, :index
    end

    resources "/locations", LocationController, except: [:new, :edit] do
      get "/events", EventController, :index
    end

    resources "/events", EventController, except: [:new, :edit]
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
