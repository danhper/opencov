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
  end

  scope "/", Opencov do
    pipe_through :browser

    get "/", PageController, :index

    resources "/projects", ProjectController
  end
end
