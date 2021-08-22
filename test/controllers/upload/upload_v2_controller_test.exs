defmodule Librecov.Api.V1.UploadV2ControllerTest do
  use Librecov.ConnCase
  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "https://api.github.com/app/installations"} ->
        json(%{}, status: 200)
    end)

    conn = build_conn() |> put_req_header("content-type", "text/plain")
    {:ok, conn: conn}
  end

  test "returns 422 when data not sent", %{conn: conn} do
    conn = post(conn, codecov_path(conn, :v2), "")
    assert json_response(conn, 422)
  end

  test "returns 422 when project token not given", %{conn: conn} do
    payload = Jason.encode!(%{json: Jason.encode!(Librecov.Fixtures.dummy_coverage())})
    conn = post(conn, codecov_path(conn, :v2), payload)
    assert json_response(conn, 422)
  end

  test "returns 404 when inexistent token given", %{conn: conn} do
    data = Librecov.Fixtures.dummy_codecov()

    assert_raise Ecto.NoResultsError, fn ->
      post(conn, "#{codecov_path(conn, :v2)}?token=fdsgsdfdsfsdf&commit=qwerasdf", data)
    end
  end

  test "creates job when project exists", %{conn: conn} do
    project = insert(:project)

    data = Librecov.Fixtures.dummy_codecov()

    conn = post(conn, "#{codecov_path(conn, :v2)}?token=#{project.token}&commit=qwerasdf", data)
    assert json_response(conn, 200)

    build =
      Librecov.Build.for_commit(project, %{"branch" => "", "head" => %{"id" => "qwerasdf"}})
      |> Librecov.Repo.first()

    assert build
    assert build.completed == true
    job = List.first(Librecov.Repo.preload(build, :jobs).jobs)
    assert job
    assert job.files_count == 106
  end
end
