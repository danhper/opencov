defmodule Librecov.FileController do
  use Librecov.Web, :controller

  alias Librecov.File

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id) |> Librecov.Repo.preload(job: [build: :project])
    file_json = Jason.encode!(file)
    render(conn, "show.html", file: file, file_json: file_json)
  end
end
