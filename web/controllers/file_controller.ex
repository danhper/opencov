defmodule Opencov.FileController do
  use Opencov.Web, :controller

  alias Opencov.File

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id) |> Opencov.Repo.preload(job: [build: :project])
    file_json = Jason.encode!(file)
    render(conn, "show.html", file: file, file_json: file_json)
  end
end
