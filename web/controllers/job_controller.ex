defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job
  alias Opencov.FileService

  def show(conn, %{"id" => id} = params) do
    job = Repo.get!(Job, id) |> Opencov.Repo.preload(build: :project)
    file_params = FileService.files_with_filter(job, params)
    render(conn, "show.html", [{:job, job}|file_params])
  end
end
