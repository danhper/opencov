defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job

  def show(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)
    files = Opencov.File.for_job(job)
    render(conn, "show.html", job: job, files: files)
  end
end
