defmodule Librecov.Services.Authorizations do
  alias Librecov.Repo
  alias Librecov.User.Authorization
  alias Librecov.Services.Github.Auth

  use EctoResource

  using_repo(Repo) do
    resource(Authorization)
  end

  def ensure_fresh(%Authorization{expires_at: expires_at} = auth) do
    now = (Timex.now() |> Timex.to_unix()) + 60

    if now < expires_at do
      {:ok, auth}
    else
      with {:ok, %{token: new_token}} <-
             Auth.github_client()
             |> Map.put(:token, %{refresh_token: auth.refresh_token})
             |> OAuth2.Client.refresh_token() do
        auth |> Authorization.changeset(new_token |> Map.from_struct()) |> Repo.update()
      end
    end
  end

  def find_or_update_by(%Ueberauth.Auth{provider: provider, uid: uid, credentials: credentials}) do
    provider = provider |> to_string()
    uid = uid |> to_string()
    authorization = Repo.get_by(Authorization, provider: provider, uid: uid)

    if is_nil(authorization) do
      nil
    else
      with {:ok, updated_authorization} <-
             Authorization.changeset(
               authorization,
               %{provider: provider, uid: uid} |> Map.merge(credentials |> Map.from_struct())
             )
             |> Repo.update() do
        {:ok, updated_authorization}
      end
    end
  end
end
