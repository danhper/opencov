defmodule Opencov.Helpers.Navigation do
  import Plug.Conn, only: [put_session: 3, get_session: 2]

  @flash_key :internal_previous_path

  def put_previous_path(conn, path) do
    put_session(conn, @flash_key, path)
  end

  def previous_path(conn, opts \\ []) do
    get_session(conn, @flash_key) || opts[:default]
  end
end
