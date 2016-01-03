defmodule Opencov.JobControllerTest do
  use Opencov.ConnCase

  setup do
    conn = conn() |> with_login
    {:ok, conn: conn}
  end

  test "redirects when not logged in" do
    job = create(:job)
    conn = conn()
    conn = get conn, job_path(conn, :show, job)
    assert redirected_to(conn) == auth_path(conn, :login)
  end

  test "shows chosen resource", %{conn: conn} do
    job = create(:job)
    conn = get conn, job_path(conn, :show, job)
    assert html_response(conn, 200) =~ "#{job.job_number}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, job_path(conn, :show, -1)
    end
  end
end
