use Mix.Config

runtime_config_path = Path.join(__DIR__, "runtime.exs")

config :opencov, Opencov.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "tfYGCfFfu10pV8G5gtUJ1do3LDwnu+eWBfL1sNtK8+bEwo6gNzFQZtWkdNQVlt+V",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Opencov.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :opencov,
  badge_format: "svg",
  runtime_config_path: runtime_config_path,
  runtime: []

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
  sender: "info@opencov.io"

import_config "#{Mix.env}.exs"

if File.exists?(runtime_config_path), do: import_config runtime_config_path
