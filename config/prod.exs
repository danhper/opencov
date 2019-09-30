use Mix.Config

config :opencov, Opencov.Endpoint,
  http: [port: System.get_env("PORT")],
  url: [
    scheme: System.get_env("OPENCOV_SCHEME") || "https",
    host: System.get_env("OPENCOV_HOST") || "demo.opencov.com",
    port: System.get_env("OPENCOV_PORT") || 443
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("PGSQL_DBNAME"),
  username: System.get_env("PGSQL_USERNAME"),
  password: System.get_env("PGSQL_PASSWORD"),
  hostname: System.get_env("PGSQL_HOST"),
  port: System.get_env("PGSQL_PORT"),
  pool_size: String.to_integer(System.get_env("PGSQL_POOL_SIZE") || "10")

config :opencov, :auth,
  enable: System.get_env("OPENCOV_AUTH") == "true",
  username: System.get_env("OPENCOV_USER"),
  password: System.get_env("OPENCOV_PASSWORD"),
  realm: System.get_env("OPENCOV_REALM") || "Protected OpenCov"

config :logger, level: :info

if File.exists?(Path.join(__DIR__, "prod.secret.exs")) do
  import_config "prod.secret.exs"
end
