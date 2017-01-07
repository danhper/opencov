use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :opencov, Opencov.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :excoveralls, :endpoint, System.get_env("COVERALLS_ENDPOINT") || "https://demo.opencov.com"

config :comeonin,
  bcrypt_log_rounds: 4,
  pbkdf2_rounds: 1

# Configure your database
config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "opencov_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
