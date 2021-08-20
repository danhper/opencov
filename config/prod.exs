use Mix.Config

config :librecov, Librecov.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [
    scheme: System.get_env("LIBRECOV_SCHEME") || "https",
    host: System.get_env("LIBRECOV_HOST") || "librecov.com",
    port: System.get_env("LIBRECOV_PORT") || 443
  ],
  static_url: [
    scheme: System.get_env("LIBRECOV_SCHEME") || "https",
    host: System.get_env("LIBRECOV_CDN_HOST") || "cdn.librecov.com",
    port: System.get_env("LIBRECOV_PORT") || 443
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  check_origin: false

config :librecov, Librecov.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10")

config :librecov, :auth,
  enable: System.get_env("LIBRECOV_AUTH") == "true",
  username: System.get_env("LIBRECOV_USER"),
  password: System.get_env("LIBRECOV_PASSWORD"),
  realm: System.get_env("LIBRECOV_REALM") || "Protected LibreCov"

config :logger, level: :info

config Librecov.Plug.Github,
  secret: System.get_env("LIBRECOV_GITHUB_WEBOOK_SECRET") || "super-secret",
  path: "/api/v1/github_webhook",
  action: {Librecov.GithubService, :handle}

if File.exists?(Path.join(__DIR__, "prod.secret.exs")) do
  import_config "prod.secret.exs"
end
