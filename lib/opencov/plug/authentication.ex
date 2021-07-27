defmodule Opencov.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Opencov.Helpers.Authentication

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    if user_signed_in?(conn) do
      check_admin(conn, opts)
    else
      redirect(conn, to: "/login")
    end
  end

  defp check_admin(conn, opts) do
    if current_user(conn).admin || !opts[:admin] do
      conn
    else
      redirect_with(conn, :error, "You are not authorized here.", "/")
    end
  end

  defp redirect_with(conn, flash_type, flash_message, path) do
    conn
      |> put_flash(flash_type, flash_message)
      |> redirect(to: path)
      |> halt
  end
end
