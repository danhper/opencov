defmodule Opencov.ProfileController do
  use Opencov.Web, :controller

  import Opencov.Helpers.Authentication

  def show(conn, _params) do
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
end
