defmodule Opencov.BuildControllerTest do
  use Opencov.ConnCase

  setup do
    conn = conn() |> with_login
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    build = create(:build)
    conn = get conn, build_path(conn, :show, build)
    assert html_response(conn, 200) =~ build.project.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, build_path(conn, :show, -1)
    end
  end
end
