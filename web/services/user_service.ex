defmodule Opencov.UserService do
  alias Opencov.User
  alias Opencov.UserMailer
  alias Opencov.Helpers.ConnHelpers
  alias Opencov.Repo

  def create_user(conn, user_params, invited) do
    options = [generate_token: true, generate_password: invited]
    changeset = User.changeset(%User{}, user_params, options)
    case Repo.insert(changeset) do
      {:ok, user} = res ->
        email = UserMailer.confirmation_email(user, ConnHelpers.base_url(conn), invited)
        Opencov.AppMailer.send(email)
        res
      err -> err
    end
  end
end
