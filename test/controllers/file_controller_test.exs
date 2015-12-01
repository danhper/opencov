defmodule Opencov.FileControllerTest do
  use Opencov.ConnCase

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    file = create(:file)
    conn = get conn, file_path(conn, :show, file)
    assert html_response(conn, 200) =~ file.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, file_path(conn, :show, -1)
    end
  end
end
