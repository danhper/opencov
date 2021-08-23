defmodule Librecov.Services.Users do
  alias Librecov.User
  alias Librecov.Repo
  alias Librecov.User.Authorization
  alias Librecov.Services.Authorizations

  use EctoResource

  using_repo(Repo) do
    resource(User)
  end

  def change_account(account \\ %User{}) do
    User.changeset(account, %{})
  end

  defp extract_user_params(%{
         provider: :identity,
         info: info,
         credentials: credentials
       }) do
    info |> Map.from_struct() |> Map.merge(credentials.other)
  end

  def register(%Ueberauth.Auth{provider: :identity} = params) do
    %User{}
    |> User.changeset(extract_user_params(params))
    |> Librecov.Repo.insert()
  end

  def register(%Ueberauth.Auth{} = params) do
    Repo.transaction(fn ->
      user = %User{} |> User.oauth_signup_changeset(params) |> Repo.insert!()

      %Authorization{}
      |> Authorization.changeset(extract_authorization_params(params))
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert!()

      user |> Repo.preload([:authorizations])
    end)
  end

  defp extract_authorization_params(%{
         provider: :github,
         uid: uid,
         credentials: credentials
       }) do
    %{provider: "github", uid: uid |> to_string()} |> Map.merge(credentials |> Map.from_struct())
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_or_register(%Ueberauth.Auth{provider: :identity, info: %{email: email}} = params) do
    if account = get_by_email(email) do
      {:ok, account}
    else
      register(params)
    end
  end

  def get_or_register(%Ueberauth.Auth{info: %{email: email}} = auth) do
    with {:ok, authorization} <- Authorizations.find_or_update_by(auth) do
      {:ok, authorization |> Repo.preload([:user]) |> Map.get(:user)}
    else
      _ ->
        if account = get_by_email(email) do
          with {:ok, _} <-
                 %Authorization{}
                 |> Authorization.changeset(extract_authorization_params(auth))
                 |> Ecto.Changeset.put_assoc(:user, account)
                 |> Repo.insert() do
            {:ok, account |> Repo.preload([:authorizations])}
          end
        else
          register(auth)
        end
    end
  end
end
