defmodule Opencov.UserMailer do
  use Opencov.Web, :mailer

  define_templates :confirmation, [:user, :base_url, :confirmation_url, :opts]

  def confirmation_email(user, opts \\ []) do
    confirmation_url = confirmation_url(user.confirmation_token)
    subject = if opts[:registration], do: "Welcome to Opencov", else: "Please confirm your email"
    %Mailman.Email{
      subject: subject,
      to: ["#{user.name} <#{user.unconfirmed_email}>"],
      text: confirmation_text(user, Opencov.Endpoint.url, confirmation_url, opts),
      html: confirmation_html(user, Opencov.Endpoint.url, confirmation_url, opts)
    }
  end

  defp confirmation_url(token),
    do: Opencov.Router.Helpers.user_url(Opencov.Endpoint, :confirm, token: token)
end
