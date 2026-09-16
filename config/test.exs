import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :opencov, Opencov.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

config :excoveralls, :endpoint, System.get_env("COVERALLS_ENDPOINT") || "http://demo.opencov.com"

config :bcrypt_elixir, log_rounds: 4

# Configure your database
config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "opencov_test",
  hostname: System.get_env("PGHOST", "localhost"),
  port: String.to_integer(System.get_env("PGPORT", "5432")),
  pool: Ecto.Adapters.SQL.Sandbox
