defmodule Librecov.Router do
  use Librecov.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug :fetch_live_flash
    plug :fetch_flash
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug :put_root_layout, {Librecov.LayoutView, :root}

    plug(NavigationHistory.Tracker, excluded_paths: ~w(/login /users/new))
  end

  pipeline :guardian do
    plug Librecov.Authentication.Pipeline
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :admin do
    plug Librecov.Plug.OnlyAdmin
  end

  pipeline :api do
    plug(:accepts, ["json", "txt"])
    plug(OpenApiSpex.Plug.PutApiSpec, module: Librecov.Web.ApiSpec)
  end

  scope "/auth", Librecov do
    pipe_through [:browser, :guardian]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api/v1", Librecov.Api.V1, as: :api_v1 do
    pipe_through(:api)

    resources("/jobs", JobController, only: [:create])
  end

  scope "/", Librecov do
    pipe_through(:browser)

    get("/projects/:project_id/badge.:format", ProjectController, :badge, as: :project_badge)
  end

  scope "/", Librecov do
    pipe_through(:api)
    post("/webhook", WebhookController, :create)
    post("/upload/v2", CodecovController, :v2)
  end

  scope "/", Librecov do
    pipe_through [:browser, :guardian]

    get "/", PageController, :index
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/logout", SessionController, :delete
  end

  scope "/", Librecov do
    pipe_through [:browser, :guardian]

    resources("/users", UserController, only: [:new, :create])
    get("/users/confirm", UserController, :confirm)
    get("/profile/password/reset_request", ProfileController, :reset_password_request)
    post("/profile/password/reset_request", ProfileController, :send_reset_password)
    get("/profile/password/reset", ProfileController, :reset_password)
    put("/profile/password/reset", ProfileController, :finalize_reset_password)
  end

  scope "/", Librecov do
    pipe_through [:browser, :guardian, :browser_auth]

    live "/repositories", RepositoryLive.Index, :index
    live "/repositories/new", RepositoryLive.Index, :new
    live "/repositories/:id/edit", RepositoryLive.Index, :edit

    live "/repositories/:owner/:repo", RepositoryLive.Show, :show
    live "/repositories/:id/show/edit", RepositoryLive.Show, :edit

    get("/profile", ProfileController, :show)
    put("/profile", ProfileController, :update)
    get("/profile/password/edit", ProfileController, :edit_password)
    put("/profile/password", ProfileController, :update_password)

    resources("/builds", BuildController, only: [:show])
    resources("/files", FileController, only: [:show])

    resources("/jobs", JobController, only: [:show])
  end

  scope "/old_admin", Librecov.Admin, as: :admin do
    pipe_through [:browser, :guardian, :browser_auth, :admin]

    get("/dashboard", DashboardController, :index)

    resources("/users", UserController)
    resources("/projects", ProjectController, only: [:index, :show])
    get("/settings", SettingsController, :edit)
    put("/settings", SettingsController, :update)
  end

  use Kaffy.Routes, scope: "/admin", pipe_through: [:guardian, :browser_auth, :admin]

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ReferencePhxWeb.Telemetry
    end
  end
end
