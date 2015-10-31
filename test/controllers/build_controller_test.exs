defmodule Opencov.BuildControllerTest do
  use Opencov.ConnCase

  alias Opencov.Build
  @valid_attrs %{build_number: 42, project_id: 42}
  @invalid_attrs %{project_id: nil}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, build_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing builds"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, build_path(conn, :new)
    assert html_response(conn, 200) =~ "New build"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, build_path(conn, :create), build: @valid_attrs
    assert redirected_to(conn) == build_path(conn, :index)
    assert Repo.get_by(Build, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, build_path(conn, :create), build: @invalid_attrs
    assert html_response(conn, 200) =~ "New build"
  end

  test "shows chosen resource", %{conn: conn} do
    build = Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    conn = get conn, build_path(conn, :show, build)
    assert html_response(conn, 200) =~ "Show build"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, build_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    build = Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    conn = get conn, build_path(conn, :edit, build)
    assert html_response(conn, 200) =~ "Edit build"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    build = Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    conn = put conn, build_path(conn, :update, build), build: @valid_attrs
    assert redirected_to(conn) == build_path(conn, :show, build)
    assert Repo.get_by(Build, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    build = Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    conn = put conn, build_path(conn, :update, build), build: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit build"
  end

  test "deletes chosen resource", %{conn: conn} do
    build = Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    conn = delete conn, build_path(conn, :delete, build)
    assert redirected_to(conn) == build_path(conn, :index)
    refute Repo.get(Build, build.id)
  end
end
