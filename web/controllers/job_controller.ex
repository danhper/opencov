defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job
  alias Opencov.File

  def show(conn, %{"id" => id} = params) do
    job = Repo.get!(Job, id) |> Opencov.Repo.preload(build: :project)
    files = File.for_job(job, Dict.get(params, "filter"))
    render(conn, "show.html", job: job, files: files)
  end
end
