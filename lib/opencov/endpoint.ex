defmodule Opencov.Endpoint do
  use Phoenix.Endpoint, otp_app: :opencov

  plug(Plug.Static,
    at: "/",
    from: :opencov,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  unless Mix.env() == :test do
    plug(Plug.RequestId)
    plug(Plug.Logger)
  end

  # plug :copy_req_body
  plug(Opencov.Plug.Github)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(Plug.Session,
    store: :cookie,
    key: "_opencov_key",
    signing_salt: "DBdPx/m/"
  )

  plug(Opencov.Router)
end
