defmodule Opencov.AuthController do
  use Opencov.Web, :controller

  import Opencov.Helpers.Navigation
  alias Opencov.Authentication
  alias Opencov.User
  alias Opencov.Repo

  def login(conn, _params) do
    render(conn, "login.html", email: "", error: nil, can_signup: can_signup?)
  end

  def make_login(conn, %{"login" => %{"email" => email, "password" => password}}) do
    if user = User.authenticate(Repo.get_by(User, email: email), password) do
      conn |> Authentication.login(user) |> redirect(to: previous_path(conn, default: "/"))
    else
      render(conn, "login.html", email: email, error: "Wrong email or password", can_signup: can_signup?)
    end
  end

  def make_login(conn, _params) do
    render(conn, "login.html", email: "", error: "You need to provide your email and password")
  end

  defp can_signup? do
    Opencov.Settings.get!.signup_enabled
  end

  def logout(conn, _params) do
    conn
    |> Authentication.logout
    |> redirect(to: auth_path(conn, :login))
  end
end
