defmodule Opencov.Plug.Navigation do
  def init(opts) do
    Keyword.put_new(opts, :excluded_paths, [])
  end

  def call(conn, opts) do
    if conn.method == "GET" and not (conn.request_path in opts[:excluded_paths]) do
      Opencov.Helpers.Navigation.put_previous_path(conn, conn.request_path)
    else
      conn
    end
  end
end
