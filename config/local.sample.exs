use Mix.Config

config :opencov, Opencov.Endpoint,
  http: [port: 4000],
  url: [scheme: "SCHEME", host: "URLHOST", port: PORT],
  secret_key_base: "SECRET_KEY"

config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "opencov_prod",
  username: "DB_USERNAME",
  password: "DB_PASSWORD",
  hostname: "DB_HOSTNAME"

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

config :phoenix, :json_library, Poison

config :opencov, :openid_connect_providers,
  keycloak: [
    discovery_document_uri: "https://access.thon.org/auth/realms/THON/.well-known/openid-configuration",
    client_id: "opencov",
    client_secret: "KEYCLOAK_SECRET",
    redirect_uri: "SCHEME://URLHOST/login/callback",
    response_type: "code",
    scope: "openid email profile"
  ]

config :opencov,
  admin_roles: [
    "ec.Executive",
    "ec.Technology",
    "tech.LeadSystemsAdministrator"
  ],
  permitted_roles: [
    "ec.Executive",
    "tech.all"
  ]

config :phoenix_live_reload,
  dirs: [
    "lib/opencov",
  ],
  backend: :fs_poll,
  backend_opts: [
    interval: 500
  ]
