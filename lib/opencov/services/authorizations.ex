defmodule Librecov.Services.Authorizations do
  alias Librecov.User
  alias Librecov.Repo
  alias Librecov.User.Authorization
  alias Librecov.Services.Users

  use EctoResource

  using_repo(Repo) do
    resource(Authorization)
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
