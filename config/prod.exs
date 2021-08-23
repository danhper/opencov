use Mix.Config

config :tesla, Tesla.Middleware.Logger, filter_headers: ["authorization"]

config :librecov, Librecov.Endpoint,
  http: [port: {:system, "PORT"}, compress: true],
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

config :logger, :console, metadata: [:request_id, :mfa]

config :logger, level: :info

config Librecov.Plug.Github,
  secret: System.get_env("LIBRECOV_GITHUB_WEBOOK_SECRET") || "super-secret",
  path: "/api/v1/github_webhook",
  action: {Librecov.GithubService, :handle}

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: System.get_env("RELEASE_LEVEL") || :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod, :staging]

config :logger, Sentry.LoggerBackend,
  level: :error,
  excluded_domains: [],
  capture_log_messages: true

config :event_bus_logger,
  enabled: {:system, "EB_LOGGER_ENABLED", "true"},
  level: {:system, "EB_LOGGER_LEVEL", :info},
  topics: {:system, "EB_LOGGER_TOPICS", ".*"},
  light_logging: {:system, "EB_LOGGER_LIGHT", "false"}

config :event_bus,
  error_handler: {Librecov.Helpers.SentryErrorLogger, :log}

if File.exists?(Path.join(__DIR__, "prod.secret.exs")) do
  import_config "prod.secret.exs"
end
