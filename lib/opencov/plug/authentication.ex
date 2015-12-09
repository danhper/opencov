defmodule Opencov.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    if user = current_user(conn) do
      if user.admin || !opts[:admin] do
        %{conn | assigns: Dict.put(conn.assigns, :current_user, user)}
      else
        redirect_with(conn, :error, "You are not authorized here.", "/")
      end
    else
      redirect_with(conn, :info, "Please login", "/login")
    end
  end

  defp redirect_with(conn, flash_type, flash_message, path) do
    conn
      |> put_flash(flash_type, flash_message)
      |> redirect(to: path)
      |> halt
  end

  defp current_user(conn) do
    if user_id = get_session(conn, Opencov.Authentication.user_id_key) do
      Opencov.Repo.get(Opencov.User, user_id)
    end
  end
end
