defmodule Opencov.JobController do
  use Opencov.Web, :controller

  alias Opencov.Job
  alias Opencov.Helpers.FileControllerHelpers

  def show(conn, %{"id" => id} = params) do
    job = Repo.get!(Job, id) |> Opencov.Repo.preload(build: :project)
    file_params = FileControllerHelpers.files_with_filter(job, params)
    render(conn, "show.html", [{:job, job}|file_params])
  end
end
