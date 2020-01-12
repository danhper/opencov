defmodule Opencov.UserController do
  use Opencov.Web, :controller

  alias Opencov.User
  alias Opencov.UserManager
  import Opencov.Helpers.Authentication

  alias Opencov.UserService

  plug :scrub_params, "user" when action in [:create, :update]
  plug :check_signup when action in [:new, :create]

  def new(conn, _params) do
    changeset = UserManager.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserService.create_user(make_user_params(user_params), invited?: false) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Please confirm your email address.")
        |> redirect(to: auth_path(conn, :login))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def confirm(conn, %{"token" => token}) do
    case UserService.confirm_user(token) do
      {:ok, user, message} ->
        conn
        |> put_flash(:info, message)
        |> finalize_confirm(user)
      {:error, err} -> redirect_to_top_with_error(conn, err)
    end
  end
  def confirm(conn, _params),
    do: redirect_to_top_with_error(conn, "The URL seems wrong, double check your email")

  defp finalize_confirm(conn, user) do
    if user.password_initialized do
      conn |> redirect(to: auth_path(conn, :login))
    else
      conn |> Opencov.Authentication.login(user) |> redirect(to: profile_path(conn, :edit_password))
    end
  end

  defp redirect_to_top_with_error(conn, err) do
    redirect_path = if user_signed_in?(conn), do: "/", else: auth_path(conn, :login)
    conn |> put_flash(:error, err) |> redirect(to: redirect_path)
  end

  defp make_user_params(params) do
    params |> Map.delete("admin")
  end

  defp check_signup(conn, _) do
    if Opencov.SettingsManager.get!.signup_enabled do
      conn
    else
      conn
      |> put_flash(:info, "Signup is disabled. Contact your administrator if you need an account.")
      |> redirect(to: auth_path(conn, :login))
      |> halt
    end
  end
end
