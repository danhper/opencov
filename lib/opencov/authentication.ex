defmodule Opencov.Authentication do
  alias Opencov.User
  alias Opencov.UserManager
  alias Opencov.UserService
  alias Opencov.Repo

  import Plug.Conn, only: [put_session: 3, delete_session: 2]

  @user_id_key :user_id

  def login(conn, email, name, roles) do
    userToLogin = Repo.get_by(User, email: email)
    
    admin_roles = Application.get_all_env(:opencov)[:admin_roles]
    assign_admin = not MapSet.disjoint?(MapSet.new(admin_roles), MapSet.new(roles))

    if is_nil(userToLogin) do
      changeset = UserManager.changeset(%User{}, %{email: email, name: name, admin: assign_admin})
      case Repo.insert(changeset) do
        {:ok, user} = res ->
          userToLogin = user
          UserService.finalize_confirmation!(userToLogin)
          put_session(conn, user_id_key(), userToLogin.id)
        err -> 
          err
      end
    else
      UserManager.changeset(userToLogin, %{admin: assign_admin}) |> Repo.update!
      put_session(conn, user_id_key(), userToLogin.id)
    end
  end

  def logout(conn) do
    delete_session(conn, user_id_key())
  end

  def user_id_key() do
    @user_id_key
  end
end
