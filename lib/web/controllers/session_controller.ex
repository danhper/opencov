defmodule Librecov.SessionController do
  use Librecov.Web, :controller

  alias Librecov.Services.Users
  alias Librecov.Authentication
  alias Ueberauth.Strategy.Helpers, as: Uauth

  def new(conn, _params) do
    if Authentication.get_current_account(conn) do
      redirect(conn, to: Routes.profile_path(conn, :show))
    else
      render(
        conn,
        :new,
        changeset: Users.change_account(),
        action: Routes.session_path(conn, :create)
      )
    end
  end

  def create(conn, %{"account" => %{"email" => email, "password" => password}}) do
    case email |> Users.get_by_email() |> Authentication.authenticate(password) do
      {:ok, account} ->
        conn
        |> Authentication.log_in(account)
        |> redirect(to: Routes.profile_path(conn, :show))

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> new(%{})
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.log_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
