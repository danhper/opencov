defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job
  alias Opencov.File

  def show(conn, %{"id" => id} = params) do
    job = Repo.get!(Job, id) |> Opencov.Repo.preload(build: :project)
    query = File.for_job(job) |> File.with_filter(params["filter"])
    paginator = query |> Opencov.Repo.paginate(params)
    render(conn, "show.html", job: job, files: paginator.entries, paginator: paginator)
  end
end
