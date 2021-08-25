defmodule Librecov.Views.Helper do
  alias Librecov.Router.Helpers, as: Routes
  alias Librecov.Project

  def project_path(conn, action, %Project{} = p) do
    {owner, name} = Project.name_and_owner(p)
    Routes.repository_show_path(conn, action, owner, name)
  end
end
