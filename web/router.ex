defmodule Opencov.Router do
  use Opencov.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Opencov.Plug.FetchUser
    plug Opencov.Plug.ForcePasswordInitialize
    plug NavigationHistory.Tracker, excluded_paths: ~w(/login /users/new)
    if Application.get_env(:opencov, :auth)[:enable] do
      plug BasicAuth, use_config: {:opencov, :auth}
    end
  end

  pipeline :anonymous_only do
    plug Opencov.Plug.AnonymousOnly
  end

  pipeline :authenticate do
    plug Opencov.Plug.Authentication
  end

  pipeline :authenticate_admin do
    plug Opencov.Plug.Authentication, admin: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Opencov.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/jobs", JobController, only: [:create]
  end

  scope "/", Opencov do
    pipe_through :browser

    get "/projects/:project_id/badge.:format", ProjectController, :badge, as: :project_badge
  end

  scope "/", Opencov do
    pipe_through :browser
    pipe_through :anonymous_only

    get "/login", AuthController, :login
    post "/login", AuthController, :make_login
    resources "/users", UserController, only: [:new, :create]
    get "/profile/password/reset_request", ProfileController, :reset_password_request
    post "/profile/password/reset_request", ProfileController, :send_reset_password
    get "/profile/password/reset", ProfileController, :reset_password
    put "/profile/password/reset", ProfileController, :finalize_reset_password
  end

  scope "/", Opencov do
    pipe_through :browser
    pipe_through :authenticate

    delete "/logout", AuthController, :logout

    get "/", ProjectController, :index

    get "/users/confirm", UserController, :confirm

    get "/profile", ProfileController, :show
    put "/profile", ProfileController, :update
    get "/profile/password/edit", ProfileController, :edit_password
    put "/profile/password", ProfileController, :update_password

    get "/integrations", IntegrationController, :show
    get "/integrations/github/new", Integration.GithubController, :new
    delete "/integrations/github", Integration.GithubController, :delete
    get "/integrations/github/callback", Integration.GithubController, :callback

    resources "/projects", ProjectController
    resources "/builds", BuildController, only: [:show]
    resources "/files", FileController, only: [:show]

    resources "/jobs", JobController, only: [:show]
  end

  scope "/admin", Opencov.Admin, as: :admin do
    pipe_through :browser
    pipe_through :authenticate_admin

    get "/", DashboardController, :index

    resources "/users", UserController
    resources "/projects", ProjectController, only: [:index, :show]
    get "/settings", SettingsController, :edit
    put "/settings", SettingsController, :update
  end
end
