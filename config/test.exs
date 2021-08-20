use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :opencov, Opencov.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :excoveralls,
       :endpoint,
       System.get_env("COVERALLS_ENDPOINT") || "http://b13e7de34700.ngrok.io"

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

config :joken,
  rs256: [
    signer_alg: "RS256",
    key_pem: """
    -----BEGIN RSA PRIVATE KEY-----
    MIIBOQIBAAJAeDkTVci2/P3lt1yFWzB9YeoPFKmbp8aGAKjs8pZesurawbmo3QIk
    DGQmrTmTjDDTbhGRyvuTn7ggB2p62F0nLQIDAQABAkASMLCYPjJRvSjQwZL75S5T
    blKx0afXjtYfq2+OlOnnMCNXJ5jtk6nqfI/Nv0hYuieXeIWayfC1rrWxmng9Ym6R
    AiEA20VMxxeSlASh6M6N+Tg4EytzIHjEhNvylkHCdSIil2MCIQCMXHCY7/d5xbT2
    3Y7XJvxbbeKSSADa7yiw5wHrsTP0LwIhAK1j74LAMTi7MQ1XyQz6V91Qzoku9rfY
    9cu71HmrtI7hAiB/C8z/IXWnS0UZjkGUjT0upK/IKFRd1svGE9KxO5wDEQIgUOv8
    NnTX1NtsEv2tWklSraAadiqnVN1loGr2gKBZ9ZE=
    -----END RSA PRIVATE KEY-----
    """
  ]

config :tesla, adapter: Tesla.Mock
