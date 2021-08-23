defmodule Librecov.ProjectView do
  use Librecov.Web, :view

  import Librecov.CommonView

  def project_badge_path(conn, project) do
    Routes.project_badge_path(
      conn,
      :badge,
      project,
      Application.get_env(:librecov, :badge_format)
    )
  end

  def project_badge_url(conn, project) do
    Routes.project_badge_url(conn, :badge, project, Application.get_env(:librecov, :badge_format))
  end
end
