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
    plug Opencov.Plug.Navigation, excluded_paths: ~w(/login /users/new)
    if Application.get_env(:opencov, PlugBasicAuth)[:enable] do
      plug PlugBasicAuth,
        username: Application.get_env(:opencov, PlugBasicAuth)[:username],
        password: Application.get_env(:opencov, PlugBasicAuth)[:password]
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
    pipe_through :anonymous_only

    get "/login", AuthController, :login
    post "/login", AuthController, :make_login
    resources "/users", UserController, only: [:new, :create]
  end

  scope "/", Opencov do
    pipe_through :browser
    pipe_through :authenticate

    delete "/logout", AuthController, :logout

    get "/", ProjectController, :index

    resources "/users", UserController, only: [:edit, :update]
    get "/users/confirm", UserController, :confirm

    get "/profile", UserController, :profile
    get "/profile/password/edit", UserController, :edit_password
    put "/profile/password", UserController, :update_password

    resources "/projects", ProjectController do
      get "/badge.:format", ProjectController, :badge, as: :badge
    end
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
