defmodule BokkenWeb.Router do
  use BokkenWeb, :router
  use Kaffy.Routes, scope: "/admin", pipe_through: [:authenticated, :admin, :protect_from_forgery]

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug :fetch_session
    plug BokkenWeb.Auth.Pipeline
  end

  pipeline :admin do
    plug BokkenWeb.Auth.AllowedRoles, [:organizer]
  end

  scope "/", BokkenWeb do
    get "/", PageController, :index
    get "/humans.txt", FileController, :humans_txt

    pipe_through :authenticated

    get "/uploads/:type/:id/:file", FileController, :files
    get "/uploads/snippets/:user_id/:lecture_id/:file", FileController, :snippets
  end

  scope "/api", BokkenWeb do
    pipe_through :api

    scope "/auth" do
      pipe_through [:fetch_session]
      post "/sign_up", AuthController, :sign_up
      post "/sign_in", AuthController, :sign_in
      post "/verify", AuthController, :verify

      pipe_through :authenticated

      resources "/me", AuthController, only: [:show, :create, :update], singleton: true
      post "/resend", AuthController, :resend
      delete "/sign_out", AuthController, :sign_out
    end

    pipe_through :authenticated

    resources "/guardians", GuardianController, except: [:new, :edit]

    resources "/mentors", MentorController, except: [:new, :edit] do
      get "/teams", TeamController, :index
      get "/files", FileController, :index
      resources "/skills", SkillController, only: [:index, :create, :delete]
    end

    resources "/skills", SkillController, except: [:new, :edit]

    resources "/organizers", OrganizerController, except: [:new, :edit]

    resources "/ninjas", NinjaController, except: [:new, :edit] do
      resources "/badges", BadgeController, only: [:index, :create, :delete]
      get "/teams", TeamController, :index
      get "/files", FileController, :index
      resources "/skills", SkillController, only: [:index, :create, :delete]
    end

    resources "/badges", BadgeController, except: [:new, :edit] do
      get "/ninjas", NinjaController, :index
    end

    resources "/teams", TeamController, except: [:new, :edit] do
      resources "/ninjas", NinjaController, only: [:index, :create, :delete]
      resources "/mentors", MentorController, only: [:index, :create, :delete]
      get "/events", EventController, :index
    end

    resources "/locations", LocationController, except: [:new, :edit] do
      get "/events", EventController, :index
    end

    resources "/events", EventController, except: [:new, :edit] do
      resources "/ninjas", NinjaController, only: [:index, :create]
      resources "/mentors", MentorController, only: [:index, :create]

      resources "/enrollments", EnrollmentController, except: [:new, :edit]
      resources "/availabilities", AvailabilityController, except: [:new, :edit, :delete]

      resources "/pairings", PairingController 
    end

    resources "/lectures", LectureController, except: [:new, :edit]

    resources "/files", FileController, except: [:new, :edit]
  end

  if Mix.env() in [:dev, :prod, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      # Enables LiveDashboard only for development
      #
      # If you want to use the LiveDashboard in production, you should put
      # it behind authentication and allow only admins to access it.
      # If your application does not have an admins-only section yet,
      # you can use Plug.BasicAuth to set up some basic authentication
      # as long as you are also using SSL (which you should anyway).
      live_dashboard "/sysadmin", metrics: BokkenWeb.Telemetry, ecto_repos: [Bokken.Repo]

      # Enables the Swoosh mailbox preview in development.
      #
      # Note that preview only shows emails that were sent by the same
      # node running the Phoenix server.
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
