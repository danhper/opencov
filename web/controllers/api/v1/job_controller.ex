defmodule Api.V1.JobController do
  use Opencov.Web, :controller

  def create(conn, %{"repo_token" => token} = params) do
    project = Opencov.Project.find_by_token!(token)
    {_, job} = Opencov.Project.add_job!(project, params)
    IO.inspect(job)
    render conn, "show.json", job: job
  end

  def create(conn, _) do
    conn
      |> put_status(400)
      |> json %{"error" => "missing 'repo_token' parameter"}
  end
end
