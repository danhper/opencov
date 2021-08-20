defmodule Librecov.JobController do
  use Librecov.Web, :controller

  alias Librecov.Job
  alias Librecov.FileService

  def show(conn, %{"id" => id} = params) do
    job = Repo.get!(Job, id) |> Librecov.Repo.preload(build: :project)
    file_params = FileService.files_with_filter(job, params)
    render(conn, "show.html", [{:job, job} | file_params])
  end
end
