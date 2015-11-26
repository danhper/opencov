defmodule Opencov.FileControllerTest do
  use Opencov.ConnCase

  alias Opencov.File

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov"}
  @build_attrs %{coverage: 50.4, project_id: 42, build_number: 1}
  @job_attrs %{job_number: 42}

  @valid_attrs %{name: "some content", source: "some content", coverage_lines: [], job_id: 30}
  @invalid_attrs %{job_id: nil}

  setup do
    conn = conn()
    project = Opencov.Repo.insert! Opencov.Project.changeset(%Opencov.Project{}, @project_attrs)
    build = Opencov.Repo.insert! Opencov.Build.changeset(%Opencov.Build{}, Dict.merge(@build_attrs, project_id: project.id))
    job = Opencov.Repo.insert! Opencov.Job.changeset(%Opencov.Job{}, Dict.merge(@job_attrs, build_id: build.id))
    valid_attrs = Dict.put(@valid_attrs, :job_id, job.id)
    {:ok, conn: conn, build: build, valid_attrs: valid_attrs}
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    file = Repo.insert! File.changeset(%File{}, valid_attrs)
    conn = get conn, file_path(conn, :show, file)
    assert html_response(conn, 200) =~ file.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, file_path(conn, :show, -1)
    end
  end
end
