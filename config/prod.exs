use Mix.Config

config :opencov, Opencov.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [
    scheme: System.get_env("OPENCOV_SCHEME") || "https",
    host: System.get_env("OPENCOV_HOST") || "demo.opencov.com",
    port: System.get_env("OPENCOV_PORT") || 443
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10")

config :opencov, :auth,
  enable: System.get_env("OPENCOV_AUTH") == "true",
  username: System.get_env("OPENCOV_USER"),
  password: System.get_env("OPENCOV_PASSWORD"),
  realm: System.get_env("OPENCOV_REALM") || "Protected OpenCov"

config :logger, level: :info

if File.exists?(Path.join(__DIR__, "prod.secret.exs")) do
  import_config "prod.secret.exs"
end
