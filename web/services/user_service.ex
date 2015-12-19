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

  def confirm_user(token) do
    case Repo.get_by(User, confirmation_token: token) do
      %User{confirmed_at: nil} = user ->
        finalize_confirmation!(user)
        {:ok, user, "Your email has been confirmed successfully"}
      %User{} = user -> {:ok, user, "You are already confirmed."}
      _              -> {:error, "Could not find the user to confirm"}
    end
  end

  defp finalize_confirmation!(user) do
    changeset = User.confirmation_changeset(user, %{confirmed_at: Timex.Date.now})
    Repo.update!(changeset)
  end
end
