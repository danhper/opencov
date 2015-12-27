defmodule Opencov.Plug.ForcePasswordInitialize do
  import Opencov.Helpers.Authentication
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if user_signed_in?(conn) do
      check_password_state(conn)
    else
      conn
    end
  end

  defp check_password_state(conn) do
    user = current_user(conn)
    if user.password_initialized or allowed_path?(conn) do
      conn
    else
      redirect(conn, to: Opencov.Router.Helpers.profile_path(conn, :edit_password)) |> halt
    end
  end

  defp allowed_path?(conn) do
    conn.request_path in [
      Opencov.Router.Helpers.profile_path(conn, :edit_password),
      Opencov.Router.Helpers.profile_path(conn, :update_password),
      Opencov.Router.Helpers.auth_path(conn, :logout)
    ]
  end
end
