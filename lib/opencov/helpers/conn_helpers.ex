defmodule Opencov.Helpers.ConnHelpers do
  def base_url(conn) do
    if url = Application.get_env(:opencov, :base_url) do
      url
    else
      conn_base_url(conn)      
    end
  end

  defp conn_base_url(conn) do
    url = "#{conn.scheme}://#{conn.host}"
    case {conn.scheme, conn.port} do
      {"http", 80}   -> url
      {"https", 443} -> url
      _              -> "#{url}:#{conn.port}"
    end
  end
end
