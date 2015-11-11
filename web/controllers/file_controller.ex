defmodule Opencov.FileController do
  use Opencov.Web, :controller

  alias Opencov.File

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    file_json = Poison.encode!(file)
    render(conn, "show.html", file: file, file_json: file_json)
  end
end
