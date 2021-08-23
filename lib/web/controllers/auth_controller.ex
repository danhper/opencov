defmodule Librecov.AuthController do
  use Librecov.Web, :controller
  alias Librecov.Services.Users
  alias Librecov.Authentication

  plug Ueberauth

  def request(conn, _params) do
    # Present an authentication challenge to the user
  end

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    case Users.get_or_register(auth_data) do
      {:ok, account} ->
        conn
        |> Authentication.log_in(account)
        |> redirect(to: Routes.profile_path(conn, :show))

      {:error, _error_changeset} ->
        conn
        |> put_flash(:error, "Authentication failed.")
        |> redirect(to: Routes.registration_path(conn, :new))
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, params) do
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: Routes.registration_path(conn, :new))
  end
end
