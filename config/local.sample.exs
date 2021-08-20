use Mix.Config

config :librecov, Librecov.Endpoint,
  http: [port: 4000],
  url: [scheme: "http", host: "demo.librecov.com", port: 80],
  secret_key_base: "my-super-secret-key-base-with-64-characters-so-that-i-dont-get-an-error"

config :librecov, Librecov.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://postgres:112233@postgres/librecov_prod",
  pool_size: 20

config :librecov, :email,
  sender: "LibreCov <info@example.com>",
  smtp: [
    relay: "smtp.example.com",
    username: "info@example.com",
    password: "my-ultra-secret-password",
    port: 587,
    ssl: false,
    tls: :always,
    auth: :always
  ]
