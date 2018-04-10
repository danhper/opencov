use Mix.Config

config :excoveralls, :endpoint, System.get_env("COVERALLS_ENDPOINT") || "http://a"

config :opencov, Opencov.Endpoint,
  http: [port: 4000],
  url: [scheme: "http", host: "demo.opencov.com", port: 80],
  secret_key_base: "JCBkb2NrZXIgcnVuIC12IC9hYnNvbHV0ZS9wYXRoL3RvL2xvY2FsLmV4czovb3BlbmNvdi9jb25maWcvbG9jYWwuZXhzIHR1dmlzdGF2aWUvb3BlbmNvdiBtaXggZWN0by5zZXR1cA0K"

config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://postgres:postgres@postgres/opencov_prod",
  pool_size: 20

config :opencov, :email,
  sender: "OpenCov <info@example.com>",
  smtp: [
    relay: "smtp.example.com",
    username: "info@example.com",
    password: "my-ultra-secret-password",
    port: 587,
    ssl: false,
    tls: :always,
    auth: :always
  ]
