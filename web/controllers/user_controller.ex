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
    render(conn, "edit.html", user: user, changeset: User.changeset(user), is_profile: true)
  end

  def update(conn, %{"id" => id, "is_profile" => is_profile, "user" => user_params}) do
    is_profile = is_profile == "true"
    {redirect_path, user, flash} = if is_profile do
      {user_path(conn, :profile), current_user(conn), "Profile"}
    else
      user = Repo.get!(User, id)
      {user_path(conn, :edit, user), user, "User"}
    end
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "#{flash} updated successfully.")
        |> redirect(to: redirect_path)
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, is_profile: is_profile)
    end
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
