use Mix.Config

config :librecov, Librecov.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "tfYGCfFfu10pV8G5gtUJ1do3LDwnu+eWBfL1sNtK8+bEwo6gNzFQZtWkdNQVlt+V",
  render_errors: [accepts: ~w(html json)],
  pubsub_server: Librecov.PubSub

config :librecov,
  badge_format: "svg",
  base_url: "http://localhost:4000",
  ecto_repos: [Librecov.Repo]

config :librecov, :github, client_id: System.get_env("LIBRECOV_GITHUB_CLIENT_ID")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :json_library, Jason

config :scrivener_html,
  routes_helper: Librecov.Router.Helpers

config :librecov, PlugBasicAuth, enable: false

config :seedex, repo: Librecov.Repo

config :librecov, :email,
  sender: "LibreCov <info@librecov.com>",
  smtp: [
    relay: "smtp.mailgun.org",
    username: System.get_env("SMTP_USER") || "info@librecov.com",
    password: System.get_env("SMTP_PASSWORD") || "I wouldn't share this",
    port: 587,
    ssl: false,
    tls: :always,
    auth: :always
  ]

config :librecov, :demo,
  enabled: System.get_env("LIBRECOV_DEMO") == "true",
  email: "user@librecov.com",
  password: "password123"

config :joken,
  rs256: [
    signer_alg: "RS256",
    key_pem: System.get_env("LIBRECOV_GITHUB_SECRET_KEY")
  ]

config :event_bus, topics: [
  :pull_request_synced,
  :build_started,
  :build_finished
]

import_config "#{Mix.env()}.exs"

local_config_path = Path.expand("local.exs", __DIR__)
if File.exists?(local_config_path), do: import_config(local_config_path)
