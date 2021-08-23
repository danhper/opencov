defmodule Librecov.Services.Users do
  alias Librecov.User

  use EctoResource

  using_repo(Repo) do
    resource(User)
  end

  def change_account(account \\ %User{}) do
    User.changeset(account, %{})
  end

  def register(%Ueberauth.Auth{provider: :identity} = params) do
    %User{}
    |> User.changeset(extract_account_params(params))
    |> Librecov.Repo.insert()
  end

  def register(%Ueberauth.Auth{} = params) do
    %User{}
    |> User.oauth_changeset(extract_account_params(params))
    |> Librecov.Repo.insert()
  end

  defp extract_account_params(%{credentials: %{other: other}, info: info}) do
    info
    |> Map.from_struct()
    |> Map.merge(other)
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_or_register(%Ueberauth.Auth{info: %{email: email}} = params) do
    if account = get_by_email(email) do
      {:ok, account}
    else
      register(params)
    end
  end
end
