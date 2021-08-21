defmodule Librecov.UserMailer do
  use Librecov.Web, :mailer

  define_templates(:confirmation, [:user, :base_url, :confirmation_url, :opts])
  define_templates(:reset_password, [:user, :reset_password_url])

  def confirmation_email(user, opts \\ []) do
    confirmation_url = confirmation_url(user.confirmation_token)
    subject = if opts[:registration], do: "Welcome to Librecov", else: "Please confirm your email"

    %Mailman.Email{
      subject: subject,
      to: ["#{user.name} <#{user.unconfirmed_email}>"],
      text: confirmation_text(user, Librecov.Endpoint.url(), confirmation_url, opts),
      html: confirmation_html(user, Librecov.Endpoint.url(), confirmation_url, opts)
    }
  end

  defp confirmation_url(token),
    do: Librecov.Router.Helpers.user_url(Librecov.Endpoint, :confirm, token: token)

  def reset_password_email(user) do
    reset_password_url = reset_password_url(user.password_reset_token)

    %Mailman.Email{
      subject: "Reset your password",
      to: ["#{user.name} <#{user.email}>"],
      text: reset_password_text(user, reset_password_url),
      html: reset_password_html(user, reset_password_url)
    }
  end

  defp reset_password_url(token),
    do: Librecov.Router.Helpers.profile_url(Librecov.Endpoint, :reset_password, token: token)
end
