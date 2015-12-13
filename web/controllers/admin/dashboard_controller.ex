defmodule Opencov.Admin.DashboardController do
  use Opencov.Web, :controller

  alias Opencov.Repo

  def index(conn, _params) do
    users = Repo.latest(Opencov.User)
    projects = Repo.latest(Opencov.Project)
    settings = Opencov.Settings.get!
    render(conn, "index.html", users: users, projects: projects, settings: settings)
  end
end
