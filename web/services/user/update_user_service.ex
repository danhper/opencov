defmodule Opencov.UpdateUserService do
  def update_user(%{"user" => user_params}, user) do
    redirect_path = Opencov.Router.Helpers.user_path(Opencov.Endpoint, :profile)
    changeset = Opencov.User.changeset(user, user_params)

    case Opencov.Repo.update(changeset) do
      {:ok, user} ->
        send_email_if_needed(user, changeset)
        {:ok, user, redirect_path, flash_message(changeset)}
      {:error, changeset} ->
        {:error, user: user, changeset: changeset}
    end
  end

  defp send_email_if_needed(user, changeset) do
    if email_changed?(changeset), do: send_email(user)
  end

  defp send_email(user) do
    email = Opencov.UserMailer.confirmation_email(user)
    Opencov.AppMailer.send(email)
  end

  defp flash_message(changeset) do
    "Your profile has been changed successfully." <>
      if email_changed?(changeset), do: " Please confirm your email.", else: ""
  end

  defp email_changed?(changeset) do
    not is_nil(Ecto.Changeset.get_change(changeset, :unconfirmed_email))
  end
end
