defmodule BokkenWeb.Router do
  use BokkenWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug :fetch_session
    plug BokkenWeb.Auth.Pipeline
  end

  pipeline :active do
    plug BokkenWeb.Auth.ActiveUser
  end

  pipeline :admin do
    plug BokkenWeb.Auth.AllowedRoles, [:organizer]
  end

  pipeline :jwt_auth do
    plug BokkenWeb.Auth.JWT.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
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

    scope "/bot" do
      pipe_through :jwt_auth

      resources "/ninja", NinjaController, only: [:show, :update], param: "discord_id"
    end
  end

  scope "/api", BokkenWeb do
    pipe_through :api

    scope "/auth" do
      pipe_through [:fetch_session]
      post "/sign_up", AuthController, :sign_up
      post "/sign_in", AuthController, :sign_in
      post "/verify", AuthController, :verify

      resources "/reset_password", ResetPasswordController, only: [:create, :update]

      pipe_through [:authenticated]

      resources "/me", AuthController, only: [:show, :create, :update], singleton: true
      post "/resend", AuthController, :resend
      delete "/sign_out", AuthController, :sign_out
    end

    pipe_through [:authenticated, :active]

    scope "/admin" do
      pipe_through :admin

      resources "/users", Admin.UserController, only: [:index, :update], as: :admin_user
      resources "/mentors", Admin.MentorController, only: [:index, :update], as: :admin_mentor
      resources "/ninjas", Admin.NinjaController, only: [:index, :update], as: :admin_ninja
      resources "/tokens", TokenController, except: [:new, :edit]

      resources "/guardians", Admin.GuardianController,
        only: [:index, :update],
        as: :admin_guardian
    end

    post "/accounts/:ninja_id", AuthController, :create

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
      resources "/enrollments", EnrollmentController, only: [:index]
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

      resources "/pairings", PairingController, only: [:index, :create]
    end

    resources "/lectures", LectureController, except: [:new, :edit]

    resources "/files", FileController, except: [:new, :edit]

    post "/notify_signup", EventController, :notify_signup
    post "/notify_selected", EventController, :notify_selected
  end

  if Mix.env() in [:dev, :stg, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
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
