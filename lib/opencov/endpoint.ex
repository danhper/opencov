defmodule Librecov.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :librecov

  @session_options [store: :cookie, key: "_librecov_key", signing_salt: "DBdPx/m/"]

  plug(Plug.CloudFlare)

  plug(Plug.Static,
    at: "/",
    from: :librecov,
    gzip: true,
    brotli: true
  )

  plug Plug.Static,
    at: "/kaffy",
    from: :kaffy,
    gzip: false,
    only: ~w(assets)

  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  unless Mix.env() == :test do
    plug(Plug.RequestId)
    plug(Plug.Logger)
  end

  # plug :copy_req_body
  plug(Librecov.Plug.Github)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Sentry.PlugContext)

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(
    Plug.Session,
    @session_options
  )

  plug(Librecov.Router)
end
