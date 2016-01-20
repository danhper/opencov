defmodule Opencov.Admin.UserController do
  use Opencov.Web, :controller

  import Opencov.Helpers.Authentication

  alias Opencov.UserService
  alias Opencov.User
  alias Opencov.Repo

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, params) do
    paginator = Repo.paginate(User, params)
    render(conn, "index.html", users: paginator.entries, paginator: paginator)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserService.create_user(user_params, invited?: true) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        redirect_path = NavigationHistory.last_path(conn, 1, default: admin_user_path(conn, :show, user))
        conn
        |> put_flash(:info, "user updated successfully.")
        |> redirect(to: redirect_path)
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    if current_user(conn).id == user.id do
      conn
        |> put_flash(:error, "You cannot delete yourself.")
        |> redirect(to: NavigationHistory.last_path(conn, default: admin_user_path(conn, :index)))
    else
      Repo.delete!(user)

      conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: admin_user_path(conn, :index))
    end
  end
end
