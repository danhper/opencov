defmodule Opencov.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if user = current_user(conn) do
      %{conn | assigns: Dict.put(conn.assigns, :current_user, user)}
    else
      conn
        |> redirect(to: "/login")
        |> halt
    end
  end

  defp current_user(conn) do
    if user_id = get_session(conn, Opencov.Authentication.user_id_key) do
      Opencov.Repo.get(Opencov.User, user_id)
    end
  end
end
