use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :librecov, Librecov.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [
    {Path.expand("node_modules/.bin/webpack-cli"),
     [
       "watch",
       "--color",
       "--progress",
       cd: Path.expand("../", __DIR__)
     ]}
  ]

# Watch static and templates for browser reloading.
config :librecov, Librecov.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$},
      ~r"lib/my_app_web/live/.*(sface)$"
    ]
  ]

config :surface, :components, [
  {Surface.Components.Form.ErrorTag,
   default_translator: {MyAppWeb.ErrorHelpers, :translate_error}}
]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :librecov, Librecov.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "librecov_dev",
  hostname: "localhost",
  pool_size: 10

config :librecov, :email,
  sender: "LibreCov <info@librecov.com>",
  smtp: [
    relay: "127.0.0.1",
    port: 1025,
    ssl: false,
    tls: :never,
    auth: :never
  ]

config Librecov.Plug.Github,
  secret: "my-secret",
  path: "/api/v1/github_webhook",
  action: {Librecov.GithubService, :handle}
