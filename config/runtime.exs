import Config

if config_env() == :prod do
  endpoint = Application.fetch_env!(:opencov, Opencov.Endpoint)
  url = Keyword.get(endpoint, :url, [])
  http = Keyword.get(endpoint, :http, [])

  config :opencov, Opencov.Endpoint,
    http:
      Keyword.put(
        http,
        :port,
        String.to_integer(System.get_env("PORT", to_string(http[:port] || 4000)))
      ),
    url:
      Keyword.merge(url,
        scheme: System.get_env("OPENCOV_SCHEME", url[:scheme] || "https"),
        host: System.get_env("OPENCOV_HOST", url[:host] || "localhost"),
        port: String.to_integer(System.get_env("OPENCOV_PORT", to_string(url[:port] || 443)))
      ),
    secret_key_base: System.get_env("SECRET_KEY_BASE") || endpoint[:secret_key_base]

  if database_url = System.get_env("DATABASE_URL") do
    config :opencov, Opencov.Repo,
      url: database_url,
      pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE", "10"))
  end

  auth = Application.get_env(:opencov, :auth, [])

  auth =
    if enabled = System.get_env("OPENCOV_AUTH"),
      do: Keyword.put(auth, :enable, enabled == "true"),
      else: auth

  auth =
    Enum.reduce(
      [username: "OPENCOV_USER", password: "OPENCOV_PASSWORD", realm: "OPENCOV_REALM"],
      auth,
      fn {key, name}, opts ->
        if value = System.get_env(name), do: Keyword.put(opts, key, value), else: opts
      end
    )

  config :opencov, :auth, auth

  email = Application.fetch_env!(:opencov, :email)
  smtp = email[:smtp]
  smtp = if user = System.get_env("SMTP_USER"), do: Keyword.put(smtp, :username, user), else: smtp

  smtp =
    if password = System.get_env("SMTP_PASSWORD"),
      do: Keyword.put(smtp, :password, password),
      else: smtp

  config :opencov, :email, Keyword.put(email, :smtp, smtp)
end
