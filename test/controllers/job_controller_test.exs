defmodule Opencov.JobControllerTest do
  use Opencov.ConnCase

  alias Opencov.Job
  @build_attrs %{coverage: 50.4, project_id: 42, build_number: 1}

  @valid_attrs %{job_number: 42}
  @invalid_attrs %{build_id: nil}

  setup do
    conn = conn()
    build = Opencov.Repo.insert! Opencov.Build.changeset(%Opencov.Build{}, @build_attrs)
    valid_attrs = Dict.put(@valid_attrs, :build_id, build.id)
    {:ok, conn: conn, build: build, valid_attrs: valid_attrs}
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    job = Repo.insert! Job.changeset(%Job{}, valid_attrs)
    conn = get conn, job_path(conn, :show, job)
    assert html_response(conn, 200) =~ "Show job"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, job_path(conn, :show, -1)
    end
  end
end
