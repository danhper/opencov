defmodule Opencov.UpdateUserService do
  defmodule Extras do
    import Opencov.Helpers.Authentication, only: [current_user: 1]
    import Opencov.Helpers.ConnHelpers, only: [base_url: 1]
    defstruct [:current_user, :base_url]
    def from_conn(conn) do
      %Extras{current_user: current_user(conn), base_url: base_url(conn)}
    end
  end

  def update_user(%{"user" => user_params}, extras) do
    user = extras.current_user
    redirect_fn = fn (conn) -> Opencov.Router.Helpers.user_path(conn, :profile) end
    changeset = Opencov.User.changeset(user, user_params)

    case Opencov.Repo.update(changeset) do
      {:ok, user} ->
        send_email_if_needed(user, changeset, extras.base_url)
        {:ok, user, redirect_fn, flash_message(changeset)}
      {:error, changeset} ->
        {:error, user: user, changeset: changeset}
    end
  end

  defp send_email_if_needed(user, changeset, base_url) do
    if email_changed?(changeset), do: send_email(user, base_url)
  end

  defp send_email(user, base_url) do
    email = Opencov.UserMailer.confirmation_email(user, base_url)
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
