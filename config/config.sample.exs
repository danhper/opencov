use Mix.Config

config :opencov, Opencov.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "tfYGCfFfu10pV8G5gtUJ1do3LDwnu+eWBfL1sNtK8+bEwo6gNzFQZtWkdNQVlt+V",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Opencov.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :opencov,
  badge_format: "svg",
  base_url: nil,
  ecto_repos: [Opencov.Repo]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :generators,
  migration: true,
  binary_id: false

config :scrivener_html,
  routes_helper: Opencov.Router.Helpers

config :opencov, PlugBasicAuth,
  enable: false

config :seedex, repo: Opencov.Repo

config :opencov, :email,
  sender: "OpenCov <info@opencov.com>",
  smtp: [
    relay: "smtp.mailgun.org",
    username: System.get_env("SMTP_USER") || "info@opencov.com",
    password: System.get_env("SMTP_PASSWORD") || "I wouldn't share this",
    port: 587,
    ssl: false,
    tls: :always,
    auth: :always
  ]

config :opencov, :demo,
  enabled: System.get_env("OPENCOV_DEMO") == "true",
  email: "user@opencov.com",
  password: "password123"

import_config "#{Mix.env}.exs"

local_config_path = Path.expand("local.exs", __DIR__)
if File.exists?(local_config_path), do: import_config local_config_path
