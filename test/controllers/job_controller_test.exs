defmodule Opencov.JobControllerTest do
  use Opencov.ConnCase

  def with_session(conn) do
    session_opts = Plug.Session.init(store: :cookie, key: "_opencov_key", signing_salt: "DBdPx/m/")
    conn
    |> Map.put(:secret_key_base, Application.get_env(:opencov, Opencov.Endpoint)[:secret_key_base])
    |> Plug.Session.call(session_opts)
    |> Plug.Conn.fetch_session
  end

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    job = create(:job)
    user = create(:user)
    conn = conn |> with_session |> Opencov.Authentication.login(user)
    conn = get conn, job_path(conn, :show, job)
    assert html_response(conn, 200) =~ "#{job.job_number}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, job_path(conn, :show, -1)
    end
  end
end
