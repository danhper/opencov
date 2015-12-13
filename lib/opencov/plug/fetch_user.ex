defmodule Opencov.Plug.FetchUser do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if user = current_user(conn) do
      %{conn | assigns: Map.put(conn.assigns, :current_user, user)}
    else
      conn
    end
  end

  defp current_user(conn) do
    if user_id = get_session(conn, Opencov.Authentication.user_id_key) do
      Opencov.Repo.get(Opencov.User, user_id)
    end
  end
end
