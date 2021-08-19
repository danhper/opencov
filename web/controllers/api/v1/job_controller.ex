defmodule Opencov.Api.V1.JobController do
  use Opencov.Web, :controller

  alias Opencov.ProjectManager

  def create(conn, %{"json" => json}) do
    json = Jason.decode!(json)
    handle_create(conn, json)
  end

  def create(conn, %{"json_file" => json_file}) do
    json = json_file |> read_file() |> Jason.decode!()
    handle_create(conn, json)
  end

  def create(conn, _) do
    conn |> bad_request("request should have 'json' or 'json_file' parameter")
  end

  defp read_file(%Plug.Upload{content_type: "gzip/json", path: path}) do
    path
    |> File.stream!()
    |> StreamGzip.gunzip()
    |> Enum.into("")
  end

  defp read_file(%Plug.Upload{path: path}) do
    path
    |> File.read!()
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
