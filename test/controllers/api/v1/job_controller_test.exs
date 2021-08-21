defmodule Librecov.Api.V1.JobControllerTest do
  use Librecov.ConnCase
  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "https://api.github.com/app/installations"} ->
        json(%{}, status: 200)
    end)

    conn = build_conn() |> put_req_header("content-type", "application/json")
    {:ok, conn: conn}
  end

  test "returns 422 when data not sent", %{conn: conn} do
    conn = post(conn, api_v1_job_path(conn, :create), "")
    assert json_response(conn, 422)
  end

  test "returns 422 when project token not given", %{conn: conn} do
    payload = Jason.encode!(%{json: Jason.encode!(Librecov.Fixtures.dummy_coverage())})
    conn = post(conn, api_v1_job_path(conn, :create), payload)
    assert json_response(conn, 422)
  end

  test "returns 404 when inexistent token given", %{conn: conn} do
    data = Map.put(Librecov.Fixtures.dummy_coverage(), "repo_token", "i-dont-exist")
    payload = Jason.encode!(%{json: Jason.encode!(data)})

    assert_raise Ecto.NoResultsError, fn ->
      post(conn, api_v1_job_path(conn, :create), payload)
    end
  end

  test "creates job when project exists", %{conn: conn} do
    project = insert(:project)
    data = Map.put(Librecov.Fixtures.dummy_coverage(), "repo_token", project.token)
    payload = Jason.encode!(%{json: Jason.encode!(data)})
    conn = post(conn, api_v1_job_path(conn, :create), payload)
    assert json_response(conn, 200)
    build = Librecov.Build.for_commit(project, data["git"]) |> Librecov.Repo.first()
    assert build
    job = List.first(Librecov.Repo.preload(build, :jobs).jobs)
    assert job
    assert job.files_count == Enum.count(data["source_files"])
  end

  test "works with multipart data", %{conn: conn} do
    project = insert(:project)
    data = Map.put(Librecov.Fixtures.dummy_coverage(), "repo_token", project.token)

    {:ok, file_path} =
      Temp.open(%{prefix: "librecov", suffix: ".json"}, &IO.write(&1, Jason.encode!(data)))

    upload = %Plug.Upload{
      path: file_path,
      filename: "coverage.json",
      content_type: "application/json"
    }

    conn = put_req_header(conn, "content-type", "multipart/form-data")
    conn = post(conn, api_v1_job_path(conn, :create), %{json_file: upload})
    assert json_response(conn, 200)
    assert Librecov.Build.for_commit(project, data["git"]) |> Librecov.Repo.first()
    File.rm!(file_path)
  end

  defp post_coverage(conn, project, coverage) do
    data = coverage |> Map.put("repo_token", project.token) |> Map.put("parallel", true)
    payload = Jason.encode!(%{json: Jason.encode!(data)})
    conn = post(conn, api_v1_job_path(conn, :create), payload)
    assert json_response(conn, 200)
    {data, json_response(conn, 200)}
  end

  test "creates parallel jobs when project exists", %{conn: conn} do
    project = insert(:project)
    post_coverage(conn, project, Librecov.Fixtures.dummy_coverage(1))
    post_coverage(conn, project, Librecov.Fixtures.dummy_coverage(2))
    {data, _} = post_coverage(conn, project, Librecov.Fixtures.dummy_coverage(3))
    build = Librecov.Build.for_commit(project, data["git"]) |> Librecov.Repo.first()
    assert build
    assert build.completed == false
    job = List.first(Librecov.Repo.preload(build, :jobs).jobs)
    assert job
    assert job.files_count == Enum.count(data["source_files"])

    payload = Jason.encode!(%{payload: %{build_num: build.build_number, status: "done"}})
    conn = post(conn, "#{webhook_path(conn, :create)}?repo_token=#{project.token}", payload)
    build = Librecov.Build.for_commit(project, data["git"]) |> Librecov.Repo.first()
    new_build = json_response(conn, 200)
    assert build.id == new_build["id"]
    assert build
    assert build.completed == true
  end
end
