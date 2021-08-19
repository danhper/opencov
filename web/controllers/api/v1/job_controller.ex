defmodule Opencov.Api.V1.JobController do
  use Opencov.Web, :controller

  alias Opencov.ProjectManager

  def create(conn, %{"json" => json}) do
    json = Jason.decode!(json)
    handle_create(conn, json)
  end

  def create(conn, %{"json_file" => %Plug.Upload{path: filepath}}) do
    json = filepath |> File.read!() |> Jason.decode!()
    handle_create(conn, json)
  end

  def create(conn, _) do
    conn |> bad_request("request should have 'json' or 'json_file' parameter")
  end

  defp handle_create(conn, %{"repo_token" => token} = params) do
    project = ProjectManager.find_by_token!(token)
    {:ok, {_, job}} = ProjectManager.add_job!(project, params)
    render(conn, "show.json", job: job)
  end

  defp handle_create(conn, _) do
    conn |> bad_request("missing 'repo_token' parameter")
  end

  defp bad_request(conn, message) do
    conn
    |> put_status(400)
    |> json(%{"error" => message})
  end
end
