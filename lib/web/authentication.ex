defmodule Librecov.Authentication do
  @moduledoc """
  Implementation module for Guardian and functions for authentication.
  """
  use Guardian, otp_app: :librecov
  alias Librecov.Services.Users
  alias Librecov.User
  alias Librecov.Repo

  def authenticated?(conn, opts \\ []) do
    __MODULE__.Plug.authenticated?(conn, opts)
  end

  def log_in(conn, account) do
    __MODULE__.Plug.sign_in(conn, account)
  end

  def get_current_account(conn) do
    __MODULE__.Plug.current_resource(conn)
  end

  def log_out(conn) do
    __MODULE__.Plug.sign_out(conn)
  end

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user(id) do
      nil -> {:error, :resource_not_found}
      account -> {:ok, account |> Repo.preload([:authorizations])}
    end
  end

  def resource_from_session(%{"guardian_default_token" => token}) do
    __MODULE__.resource_from_token(token)
  end

  def authenticate(%User{password_digest: nil}, _) do
    {:error, :dont_have_password}
  end

  def authenticate(%User{} = account, password) do
    authenticate(
      account,
      password,
      Argon2.verify_pass(password, account.password_digest)
    )
  end

  def authenticate(nil, password) do
    authenticate(nil, password, Argon2.no_user_verify())
  end

  defp authenticate(account, _password, true) do
    {:ok, account}
  end

  defp authenticate(_account, _password, false) do
    {:error, :invalid_credentials}
  end
end
