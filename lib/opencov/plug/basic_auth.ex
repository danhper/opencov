defmodule Opencov.Plug.BasicAuth do
  def init(opts), do: opts

  def call(conn, _opts) do
    config = Application.get_env(:opencov, :auth, [])

    if config[:enable] do
      Plug.BasicAuth.basic_auth(conn, Keyword.delete(config, :enable))
    else
      conn
    end
  end
end
