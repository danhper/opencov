defmodule Opencov.AuthController do
  use Opencov.Web, :controller

  alias Opencov.Authentication
  alias Opencov.User
  alias Opencov.Repo

  def login(conn, _params) do
    redirect(conn, external: OpenIDConnect.authorization_uri(:keycloak))
    # render(conn, "login.html", email: "", error: nil, can_signup: can_signup?())
  end

  def callback(conn, %{"code" => code}) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:keycloak, code),
         {:ok, claims} <- OpenIDConnect.verify(:keycloak, tokens["id_token"]) do
      permitted_roles = Application.get_all_env(:opencov)[:permitted_roles]
      permitted = not MapSet.disjoint?(MapSet.new(permitted_roles), MapSet.new(claims["roles"]))
      if permitted do
        conn
        |> Authentication.login(claims["email"], claims["name"], claims["roles"])
        |> redirect(to: "/")
      else
        conn |> send_resp(401, "Unauthorized") 
      end
    else
      _ -> send_resp(conn, 401, "")
    end
  end

  def make_login(conn, %{"login" => %{"email" => email, "password" => password}}) do
    if user = User.authenticate(Repo.get_by(User, email: email), password) do
      login_if_confirmed(conn, user)
    else
      render(conn, "login.html", email: email, error: "Wrong email or password", can_signup: can_signup?())
    end
  end

  def make_login(conn, _params) do
    render(conn, "login.html", email: "", error: "You need to provide your email and password")
  end

  defp login_if_confirmed(conn, user) do
    if is_nil(user.confirmed_at) do
      render(conn, "login.html", email: user.email, error: "Please confirm your email", can_signup: can_signup?())
    else
      conn |> Authentication.login(user) |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end

  defp can_signup?() do
    Opencov.SettingsManager.get!.signup_enabled
  end

  def logout(conn, _params) do
    conn
    |> Authentication.logout
    |> redirect(to: auth_path(conn, :login))
  end
end
