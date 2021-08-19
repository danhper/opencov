defmodule Opencov.Admin.ProjectController do
  use Opencov.Web, :controller

  alias Opencov.Project
  alias Opencov.Repo

  plug(:scrub_params, "project" when action in [:create, :update])

  def index(conn, params) do
    paginator = Repo.paginate(Project, params)
    render(conn, "index.html", projects: paginator.entries, paginator: paginator)
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    render(conn, "show.html", project: project)
  end
end
