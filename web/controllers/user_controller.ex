defmodule Opencov.UserController do
  use Opencov.Web, :controller

  alias Opencov.User
  import Opencov.Helpers.Authentication

  alias Opencov.UserService

  plug :scrub_params, "user" when action in [:create, :update]
  plug :check_signup when action in [:new, :create]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserService.create_user(conn, make_user_params(user_params), false) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Please confirm your email address.")
        |> redirect(to: auth_path(conn, :login))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def profile(conn, _params) do
    user = current_user(conn)
    render(conn, "edit.html", user: user, changeset: User.changeset(user))
  end

  def edit_password(conn, _params) do
    user = current_user(conn)
    render(conn, "edit_password.html", user: user, changeset: User.changeset(user))
  end

  def update_password(conn, %{"user" => user_params}) do
    user = current_user(conn)
    changeset = User.password_update_changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, _user} -> conn |> put_flash(:info, "Your password has been updated") |> redirect(to: "/")
      {:error, changeset} -> render(conn, "edit_password.html", user: user, changeset: changeset)
    end
  end

  def update(conn, params) do
    extras = Opencov.UpdateUserService.Extras.from_conn(conn)
    case Opencov.UpdateUserService.update_user(params, extras) do
      {:ok, _user, redirect_fn, flash_message} ->
        conn
        |> put_flash(:info, flash_message)
        |> redirect(to: redirect_fn.(conn))
      {:error, assigns} ->
        render(conn, "edit.html", assigns)
    end
  end

  def confirm(conn, %{"token" => token}) do
    case UserService.confirm_user(token) do
      {:ok, user, message} ->
        conn
        |> put_flash(:info, message)
        |> finalize_confirm(user)
      {:error, err} -> redirect_to_login_with_error(conn, err)
    end
  end
  def confirm(conn, _params),
    do: redirect_to_login_with_error(conn, "The URL seems wrong, double check your email")

  defp finalize_confirm(conn, user) do
    if user.password_initialized do
      conn |> redirect(to: auth_path(conn, :login))
    else
      conn |> Opencov.Authentication.login(user) |> redirect(to: user_path(conn, :edit_password))
    end
  end

  defp redirect_to_login_with_error(conn, err) do
    conn |> put_flash(:error, err) |> redirect(to: auth_path(conn, :login))
  end

  defp make_user_params(params) do
    params |> Map.delete("admin")
  end

  defp check_signup(conn, _) do
    if Opencov.Settings.get!.signup_enabled do
      conn
    else
      conn
      |> put_flash(:info, "Signup is disabled. Contact your administrator if you need an account.")
      |> redirect(to: auth_path(conn, :login))
      |> halt
    end
  end
end
