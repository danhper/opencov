defmodule Opencov.Endpoint do
  use Phoenix.Endpoint, otp_app: :opencov

  plug Opencov.PrometheusExporter

  plug Plug.Static,
    at: "/", from: :opencov, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Opencov.Middleware.EndpointLogging

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_opencov_key",
    signing_salt: "DBdPx/m/"

  plug Opencov.Middleware.RouterWithMonitor
end
