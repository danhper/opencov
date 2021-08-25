defmodule Librecov.ProjectController do
  use Librecov.Web, :controller

  alias Librecov.Project

  def badge(conn, %{"project_id" => id, "format" => format}) do
    project = Repo.get!(Project, id)
    {:ok, badge} = Librecov.BadgeManager.get_or_create(project, format)

    conn
    |> put_resp_content_type(MIME.type(format))
    |> send_resp(200, badge.image)
  end
end
