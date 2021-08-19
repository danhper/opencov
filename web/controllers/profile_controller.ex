defmodule Opencov.ProfileController do
  use Opencov.Web, :controller

  alias Opencov.User
  alias Opencov.UserManager

  def show(conn, _params) do
    user = current_user(conn)
    render(conn, "edit.html", user: user, changeset: UserManager.changeset(user))
  end

  def update(conn, params) do
    case Opencov.UserService.update_user(params, current_user(conn)) do
      {:ok, _user, redirect_path, flash_message} ->
        conn
        |> put_flash(:info, flash_message)
        |> redirect(to: redirect_path)
      {:error, assigns} ->
        render(conn, "edit.html", assigns)
    end
  end

  def edit_password(conn, _params) do
    user = current_user(conn)
    render(conn, "edit_password.html", user: user, changeset: UserManager.changeset(user))
  end

  def update_password(conn, %{"user" => user_params}) do
    user = current_user(conn)
    changeset = UserManager.password_update_changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, _user} -> conn |> put_flash(:info, "Your password has been updated") |> redirect(to: "/")
      {:error, changeset} -> render(conn, "edit_password.html", user: user, changeset: changeset)
    end
  end

  def reset_password_request(conn, _params) do
    render(conn, "reset_password_request.html")
  end

  def send_reset_password(conn, %{"user" => %{"email" => email}}) do
    Opencov.UserService.send_reset_password(email)
    conn
    |> put_flash(:info, "An email has been sent to reset your password.")
    |> redirect(to: auth_path(conn, :login))
  end

  def reset_password(conn, %{"token" => token}) do
    case Repo.get_by(User, password_reset_token: token) do
      %User{} = user ->
        changeset = UserManager.changeset(user)
        render(conn, "reset_password.html", user: user, changeset: changeset, token: token)
      _ -> password_reset_error(conn)
    end
  end

  def finalize_reset_password(conn, %{"user" => %{"password_reset_token" => token} = user_params}) do
    case Opencov.UserService.finalize_reset_password(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Your password has been reset.")
        |> Opencov.Authentication.login(user)
        |> redirect(to: "/")
      {:error, :not_found} -> password_reset_error(conn)
      {:error, changeset} ->
        render(conn, "reset_password.html", user: changeset.data, changeset: changeset, token: token)
    end
  end

  defp password_reset_error(conn) do
    conn
    |> put_flash(:error, "Could not reset your password. Check your email or try the process again.")
    |> redirect(to: auth_path(conn, :login))
  end
end
