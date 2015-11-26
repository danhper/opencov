defmodule Opencov.BuildControllerTest do
  use Opencov.ConnCase

  alias Opencov.Build
  alias Opencov.Project

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov"}
  @valid_attrs %{build_number: 42, project_id: 42}
  @invalid_attrs %{project_id: nil}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    build = Opencov.Repo.insert! Build.changeset(%Build{}, Dict.merge(@valid_attrs, project_id: project.id))
    conn = get conn, build_path(conn, :show, build)
    assert html_response(conn, 200) =~ project.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, build_path(conn, :show, -1)
    end
  end
end
