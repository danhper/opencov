use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :opencov, Opencov.Endpoint,
  secret_key_base: "iIX94/CQx5SnWNXI/gv8uvtz3MpQC9M7MiKZOJEY5g+YGIzmVXKXTG0+MC5mw/h6"

# Configure your database
config :opencov, Opencov.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "opencov_prod",
  pool_size: 20
