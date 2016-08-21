defmodule Opencov.IntegrationController do
  use Opencov.Web, :controller

  def show(conn, _params) do
    user = current_user(conn)
    render(conn, "show.html", user: user)
  end
end
