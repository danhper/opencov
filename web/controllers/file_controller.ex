defmodule Opencov.FileController do
  use Opencov.Web, :controller

  alias Opencov.File

  plug :scrub_params, "file" when action in [:create, :update]

  def index(conn, _params) do
    files = Repo.all(File)
    render(conn, "index.html", files: files)
  end

  def new(conn, _params) do
    changeset = File.changeset(%File{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"file" => file_params}) do
    changeset = File.changeset(%File{}, file_params)

    case Repo.insert(changeset) do
      {:ok, _file} ->
        conn
        |> put_flash(:info, "File created successfully.")
        |> redirect(to: file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    file_json = Poison.encode!(file)
    render(conn, "show.html", file: file, file_json: file_json)
  end

  def edit(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file)
    render(conn, "edit.html", file: file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file, file_params)

    case Repo.update(changeset) do
      {:ok, file} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: file_path(conn, :show, file))
      {:error, changeset} ->
        render(conn, "edit.html", file: file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(File, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    conn
    |> put_flash(:info, "File deleted successfully.")
    |> redirect(to: file_path(conn, :index))
  end
end
