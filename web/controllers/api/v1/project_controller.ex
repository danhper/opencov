defmodule Opencov.Api.V1.ProjectController do
  require Logger
  use Opencov.Web, :controller

  alias Opencov.Project

  def index(conn, params) do
    Logger.debug "Var value: #{inspect(params)}"
    paginator = Repo.paginate(Project, params)
    render conn, "index.json", projects: paginator.entries
  end

  def index(conn, _) do
    paginator = Repo.paginate(Project)
    render conn, "index.json", projects: paginator.entries
  end

  defp bad_request(conn, message) do
    conn
    |> put_status(400)
    |> json(%{"error" => message})
  end

end
