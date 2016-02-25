defmodule Opencov.UserService do
  alias Opencov.User
  alias Opencov.UserManager
  alias Opencov.UserMailer
  alias Opencov.Repo

  def create_user(user_params, opts) do
    options = [generate_token: true, generate_password: opts[:invited?]]
    changeset = UserManager.changeset(%User{}, user_params, options)
    case Repo.insert(changeset) do
      {:ok, user} = res ->
        email = UserMailer.confirmation_email(user, opts ++ [registration: true])
        Opencov.AppMailer.send(email)
        res
      err -> err
    end
  end

  def confirm_user(token) do
    case Repo.get_by(User, confirmation_token: token) do
      %User{unconfirmed_email: m} = user when not is_nil(m) ->
        finalize_confirmation!(user)
        {:ok, user, "Your email has been confirmed successfully"}
      %User{} = user -> {:ok, user, "You are already confirmed."}
      _              -> {:error, "Could not find the user to confirm"}
    end
  end

  defp finalize_confirmation!(user) do
    UserManager.confirmation_changeset(user) |> Repo.update!
  end

  def send_reset_password(email) do
    case Repo.get_by(User, email: email) do
      %User{} = user ->
        UserManager.password_reset_changeset(user)
        |> Repo.update!
        |> UserMailer.reset_password_email
        |> Opencov.AppMailer.send
        :ok
      _ -> :ok
    end
  end

  def finalize_reset_password(%{"password_reset_token" => token} = params) do
    case Repo.get_by(User, password_reset_token: token) do
      %User{} = user ->
        opts = [skip_password_validation: true, remove_reset_token: true]
        UserManager.password_update_changeset(user, params, opts) |> Repo.update
      _ -> {:error, :not_found}
    end
  end
end
