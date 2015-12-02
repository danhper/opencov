defmodule Opencov.Api.V1.JobControllerTest do
  use Opencov.ConnCase

  setup do
    conn = conn() |> put_req_header("content-type", "application/json")
    {:ok, conn: conn}
  end

  test "returns 400 when project token not given", %{conn: conn} do
    payload = Poison.encode!(%{json: Poison.encode!(Opencov.Fixtures.dummy_coverage)})
    conn = post conn, api_v1_job_path(conn, :create), payload
    assert json_response(conn, 400)
  end

  test "returns 404 when inexistent token given", %{conn: conn} do
    data = Dict.put(Opencov.Fixtures.dummy_coverage, "repo_token", "i-dont-exist")
    payload = Poison.encode!(%{json: Poison.encode!(data)})
    assert_raise Ecto.NoResultsError, fn ->
      post conn, api_v1_job_path(conn, :create), payload
    end
  end

  test "creates job when project exists", %{conn: conn} do
    project = create(:project)
    data = Dict.put(Opencov.Fixtures.dummy_coverage, "repo_token", project.token)
    payload = Poison.encode!(%{json: Poison.encode!(data)})
    conn = post conn, api_v1_job_path(conn, :create), payload
    assert json_response(conn, 200)
    build = Opencov.Build.for_commit(project, data["git"])
    assert build
    job = List.first(Opencov.Repo.preload(build, :jobs).jobs)
    assert job
    assert job.files_count == Enum.count(data["source_files"])
  end
end
