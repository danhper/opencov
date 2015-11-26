defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job
  alias Opencov.File

  def show(conn, %{"id" => id} = params) do
    filters = Dict.get(params, "filters", [])
    job = Repo.get!(Job, id) |> Opencov.Repo.preload(build: :project)
    query = File.for_job(job) |> File.with_filters(filters) |> File.order_by_coverage
    paginator = query |> Opencov.Repo.paginate(params)
    render(conn, "show.html", job: job, files: paginator.entries, paginator: paginator, filters: filters)
  end
end
