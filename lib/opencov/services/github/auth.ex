defmodule Librecov.Services.Github.Auth do
  alias ExOctocat.Connection
  alias ExOctocat.Api.Apps
  alias ExOctocat.Model.Installation
  alias Librecov.Project
  alias Librecov.Services.Github.AuthData

  def with_auth_data(nil, _), do: {:error, :nil_input}

  def with_auth_data(%Project{} = project, block) do
    with {owner, repo} <- Project.name_and_owner(project) do
      with_auth_data(owner, repo, block)
    end
  end

  def with_auth_data(nil, nil, _), do: {:error, :nil_input}

  def with_auth_data(owner, repo, block) do
    with {:ok, token} <- login_token(owner) do
      apply(block, [%AuthData{token: token, owner: owner, repo: repo}])
    end
  end

  def now, do: Timex.now() |> Timex.to_unix()

  def app_token() do
    signer = Joken.Signer.parse_config(:rs256)

    token_config =
      %{}
      |> Joken.Config.add_claim("iat", fn -> now() - 60 end)
      |> Joken.Config.add_claim("exp", fn -> now() + 60 end)
      |> Joken.Config.add_claim("iss", &github_app_id/0)

    {:ok, jwt, _} = Joken.generate_and_sign(token_config, %{}, signer)
    jwt
  end

  def login_token(login) do
    with {:ok, installations} <-
           app_token()
           |> Connection.new()
           |> Apps.apps_list_installations(),
         %Installation{id: installatin_id} <-
           installations
           |> Enum.find(fn %{account: %{login: github_login}} -> github_login == login end),
         {:ok, token} <-
           app_token()
           |> Connection.new()
           |> Apps.apps_create_installation_access_token(installatin_id) do
      {:ok, token.token}
    end
  end

  def github_client(strategy \\ OAuth2.Strategy.Refresh) do
    OAuth2.Client.new(
      strategy: strategy,
      client_id: github_client_id(),
      client_secret: github_client_secret(),
      redirect_uri: "http://myapp.com/auth/callback",
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token"
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  defp config do
    Application.get_env(:librecov, :github, [])
  end

  defp github_app_id, do: config() |> Keyword.get(:app_id, "")
  defp github_client_id, do: config() |> Keyword.get(:client_id, "")
  defp github_client_secret, do: config() |> Keyword.get(:client_secret, "")
end
