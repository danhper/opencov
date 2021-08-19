defmodule Opencov.External.GitHub.OAuth do
  use OAuth2.Strategy

  @config Application.get_all_env(:opencov)
  @gh_config Application.get_env(:opencov, :github)

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: @gh_config[:client_id],
      client_secret: @gh_config[:client_secret],
      redirect_uri: Path.join(@config[:base_url], "integrations/github/callback"),
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token"
    ])
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: @gh_config[:scope]);
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token(params \\ [], headers \\ []) do
    client = client()
    body = access_token_body(params)
    headers = [{"content-type", "application/x-www-form-urlencoded"} | headers]
    case OAuth2.Request.request(:post, client, client.token_url, body, headers, []) do
      {:ok, %OAuth2.Response{status_code: 200, body: body}} ->
        {:ok, OAuth2.AccessToken.new(Plug.Conn.Query.decode(body))}
      {:ok, %OAuth2.Response{status_code: status, body: body}} ->
        {:error, %{status_code: status, body: body}}
      {:error, _err} = error -> error
      err -> {:error, err}
    end
  end

  defp access_token_body(params) do
    base_params = Map.take(client(), [:client_id, :client_secret])
    params
    |> Enum.into(%{})
    |> Map.merge(base_params)
  end

  def get!(url, opts \\ []) do
    client = make_client(opts)
    OAuth2.Client.get!(client, url, Keyword.get(opts, :headers, []), opts).body
    |> Poison.decode!
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp make_client(opts) do
    case opts[:user] do
      %{github_access_token: token} when is_binary(token) ->
        Map.put(client(), :token, OAuth2.AccessToken.new(token))
      _ -> client()
    end
  end
end
