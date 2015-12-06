defmodule Opencov.AuthController do
  use Opencov.Web, :controller

  alias Opencov.Authentication
  alias Opencov.User
  alias Opencov.Repo

  def login(conn, _params) do
    render(conn, "login.html", email: "", error: nil)
  end

  def make_login(conn, %{"login" => %{"email" => email, "password" => password}}) do
    if user = User.authenticate(Repo.get_by(User, email: email), password) do
      conn |> Authentication.login(user) |> redirect(to: "/")
    else
      render(conn, "login.html", email: email, error: "Wrong email or password")
    end
  end

  def make_login(conn, _params) do
    render(conn, "login.html", email: "", error: "You need to provide your email and password")
  end

  def logout(conn, _params) do
    conn
    |> Authentication.logout
    |> redirect(to: auth_path(conn, :login))
  end
end
