defmodule Librecov.Admin.DashboardController do
  use Librecov.Web, :controller

  alias Librecov.Repo

  def index(conn, _params) do
    users = Repo.latest(Librecov.User)
    projects = Repo.latest(Librecov.Project)
    settings = Librecov.SettingsManager.get!()
    render(conn, "index.html", users: users, projects: projects, settings: settings)
  end
end
