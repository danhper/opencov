defmodule Opencov.Router do
  use Opencov.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    scope "/api/v1", as: :api_v1, alias: Api.V1 do
      resources "/jobs", JobController
    end
  end

  scope "/", Opencov do
    pipe_through :browser

    get "/", ProjectController, :index

    resources "/projects", ProjectController do
      get "/badge.:format", ProjectController, :badge, as: :badge
    end
    resources "/builds", BuildController, only: [:show]
    resources "/jobs", JobController, only: [:show]
    resources "/files", FileController, only: [:show]
  end
end
