defmodule Librecov.BuildController do
  use Librecov.Web, :controller

  alias Librecov.Build
  alias Librecov.FileService

  def show(conn, %{"id" => id} = params) do
    build = Repo.get!(Build, id) |> Repo.preload([:jobs, :project])
    job_ids = Enum.map(build.jobs, & &1.id)
    file_params = FileService.files_with_filter(job_ids, params)
    render(conn, "show.html", [{:build, build} | file_params])
  end
end
