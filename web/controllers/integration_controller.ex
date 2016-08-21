defmodule Opencov.IntegrationController do
  use Opencov.Web, :controller

  def show(conn, _params) do
    user = current_user(conn) |> Opencov.External.GitHub.add_user_info()
    render(conn, "show.html", user: user)
  end
end
