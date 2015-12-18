use Mix.Config

config :opencov, Opencov.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "tfYGCfFfu10pV8G5gtUJ1do3LDwnu+eWBfL1sNtK8+bEwo6gNzFQZtWkdNQVlt+V",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Opencov.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :opencov,
  badge_format: "svg"

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

config :opencov, :email,
  sender: "Opencov <info@opencov.io>",
  smtp: [
    relay: "smtp.mailgun.org",
    username: "info@opencov.io",
    password: "I wouldn't share this",
    port: 587,
    ssl: false,
    tls: :always,
    auth: :always
  ]

import_config "#{Mix.env}.exs"

local_config_path = Path.join(__DIR__, "local.exs")
if File.exists?(local_config_path), do: import_config local_config_path
