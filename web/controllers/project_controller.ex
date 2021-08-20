defmodule Librecov.ProjectController do
  use Librecov.Web, :controller

  import Librecov.Helpers.Authentication

  alias Librecov.Project
  alias Librecov.ProjectManager

  plug(:scrub_params, "project" when action in [:create, :update])

  def index(conn, _params) do
    projects = Repo.all(Project) |> ProjectManager.preload_latest_build()
    render(conn, "index.html", projects: projects)
  end

  def new(conn, _params) do
    changeset = ProjectManager.changeset(%Project{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    project = Ecto.build_assoc(current_user(conn), :projects)
    changeset = ProjectManager.changeset(project, project_params)

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: project_path(conn, :show, project))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get!(Project, id) |> ProjectManager.preload_recent_builds()
    render(conn, "show.html", project: project)
  end

  def edit(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    changeset = ProjectManager.changeset(project)
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get!(Project, id)
    changeset = ProjectManager.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:error, "Project updated successfully.")
        |> redirect(to: project_path(conn, :show, project))

      {:error, changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    Repo.delete!(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end

  def badge(conn, %{"project_id" => id, "format" => format}) do
    project = Repo.get!(Project, id)
    {:ok, badge} = Librecov.BadgeManager.get_or_create(project, format)

    conn
    |> put_resp_content_type(MIME.type(format))
    |> send_resp(200, badge.image)
  end
end
