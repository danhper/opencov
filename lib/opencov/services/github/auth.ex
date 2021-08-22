defmodule Librecov.Services.Github.Auth do
  alias ExOctocat.Connection
  alias ExOctocat.Api.Apps
  alias ExOctocat.Model.Installation
  alias Librecov.Project
  alias Librecov.Services.Github.AuthData

  def with_auth_data(nil, _), do: {:error, :nil_input}
  def with_auth_data(nil, nil, _), do: {:error, :nil_input}

  def with_auth_data(%Project{} = project, block) do
    with {owner, repo} <- Project.name_and_owner(project) do
      with_auth_data(owner, repo, block)
    end
  end

  def with_auth_data(owner, repo, block) do
    with {:ok, token} <- Auth.login_token(owner) do
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
      |> Joken.Config.add_claim("iss", &github_client_id/0)

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

  defp config do
    Application.get_env(:librecov, :github, [])
  end

  defp github_client_id, do: config() |> Keyword.get(:client_id, "")
end
