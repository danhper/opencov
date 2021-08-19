defmodule Opencov.Api.V1.GithubController do
  use Opencov.Web, :controller

  alias Opencov.ProjectManager

  def webhook(conn, opts) do
    [signature_in_header] = get_req_header(conn, "x-hub-signature")

    if verify_signature(conn.private[:raw_body], "my-secret", signature_in_header) do
      conn
      |> put_status(200)
      |> json(%{"status" => "ok"})
    else
      conn
      |> put_status(403)
      |> json(%{"status" => "forbidden"})
    end

    # IO.inspect(conn)
    # IO.inspect(opts)
    conn
  end

  defp verify_signature(payload, secret, signature_in_header) do
    signature =
      "sha1=" <> (:crypto.mac(:hmac, :sha, secret, payload) |> Base.encode16(case: :lower))

    Plug.Crypto.secure_compare(signature, signature_in_header)
  end
end
