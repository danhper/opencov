defmodule Opencov.Plug.AnonymousOnly do
  import Opencov.Helpers.Authentication
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts) do
    Keyword.put_new(opts, :redirect_to, "/")
  end

  def call(conn, opts) do
    if user_signed_in?(conn) do
      redirect(conn, to: opts[:redirect_to]) |> halt
    else
      conn
    end
  end
end
