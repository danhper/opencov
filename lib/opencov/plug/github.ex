defmodule Opencov.Plug.Github do
  import Plug.Conn
  require Logger

  def init(options) do
    options
  end

  @doc """
  Verifies secret and calls a handler with the webhook payload
  """
  def call(conn, options) do
    path = get_config(options, :path)
    IO.inspect(path)
    IO.inspect(conn.request_path)
    case conn.request_path do
      ^path ->
        secret = get_config(options, :secret)
        {module, function} = get_config(options, :action)

        {:ok, payload, _conn} = read_body(conn)
        [signature_in_header] = get_req_header(conn, "x-hub-signature")

        if verify_signature(payload, secret, signature_in_header) do
          apply(module, function, [conn, payload])
          conn |> send_resp(200, "OK") |> halt()
        else
          conn |> send_resp(403, "Forbidden") |> halt()
        end

      _ -> conn
    end
  end

  defp verify_signature(payload, secret, signature_in_header) do
    signature = "sha1=" <> (:crypto.hmac(:sha, secret, payload) |> Base.encode16(case: :lower))
    Plug.Crypto.secure_compare(signature, signature_in_header)
  end

  defp get_config(options, key) do
    options[key] || get_config(key)
  end

  defp get_config(key) do
    case Application.get_env(Opencob.Plug.Github, key) do
      nil ->
        Logger.warn "Opencob.Plug.Github config key #{inspect key} is not configured."
        ""

      val -> val
    end
  end
end
