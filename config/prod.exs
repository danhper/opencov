import Config

# Environment-specific connection settings are loaded in runtime.exs.

config :opencov, Opencov.Repo, ssl: true

config :logger, level: :info

if File.exists?(Path.join(__DIR__, "prod.secret.exs")) do
  import_config "prod.secret.exs"
end
