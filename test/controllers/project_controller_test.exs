defmodule Opencov.ProjectControllerTest do
  use Opencov.ConnCase

  import Mock

  alias Opencov.Project
  @valid_attrs Map.take(fields_for(:project), [:name, :base_url])
  @invalid_attrs %{name: nil}

  setup do
    conn = conn() |> with_login
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert html_response(conn, 200) =~ "Projects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, project_path(conn, :new)
    assert html_response(conn, 200) =~ "project"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert redirected_to(conn) == project_path(conn, :index)
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: %{}
    assert html_response(conn, 200) =~ "new"
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{name: "name"}
    conn = get conn, project_path(conn, :show, project)
    assert html_response(conn, 200) =~ project.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    project = create(:project)
    conn = get conn, project_path(conn, :edit, project)
    assert html_response(conn, 200) =~ project.name
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = put conn, project_path(conn, :update, project), project: @valid_attrs
    assert redirected_to(conn) == project_path(conn, :show, project)
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = create(:project)
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert html_response(conn, 200) =~ project.name
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = delete conn, project_path(conn, :delete, project)
    assert redirected_to(conn) == project_path(conn, :index)
    refute Repo.get(Project, project.id)
  end

  test "get badge", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_badge_path(conn, :badge, project, "svg")
    assert conn.status == 200
    assert List.first(get_resp_header(conn, "content-type")) =~ "image/svg+xml"
    assert conn.resp_body =~ "NA"

    Repo.update! %{project | current_coverage: 80.0}

    conn = get conn, project_badge_path(conn, :badge, project, "svg")
    assert List.first(get_resp_header(conn, "content-type")) =~ "image/svg+xml"
    assert conn.resp_body =~ "80"

    with_mock Opencov.BadgeCreator, [make_badge: fn(_, _) -> {:ok, :png, "badge"} end] do
      conn = get conn, project_badge_path(conn, :badge, project, "png")
      assert List.first(get_resp_header(conn, "content-type")) =~ "image/png"
    end
  end
end
