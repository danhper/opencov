defmodule Librecov.Plug.OnlyAdmin do
  import Plug.Conn
  require Logger
  alias Librecov.Authentication

  def init(options) do
    options
  end

  def call(conn, _options) do
    user = Authentication.get_current_account(conn)

    if is_nil(user) || !user.admin do
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    else
      conn
    end
  end
end
