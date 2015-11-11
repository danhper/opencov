defmodule Opencov.FileControllerTest do
  use Opencov.ConnCase

  alias Opencov.File

  @valid_attrs %{name: "some content", source: "some content", coverage_lines: [], job_id: 30}
  @invalid_attrs %{job_id: nil}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    file = Repo.insert! File.changeset(%File{}, @valid_attrs)
    conn = get conn, file_path(conn, :show, file)
    assert html_response(conn, 200) =~ "Show file"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, file_path(conn, :show, -1)
    end
  end
end
