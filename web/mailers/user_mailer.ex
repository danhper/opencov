defmodule Opencov.UserMailer do
  use Opencov.Web, :mailer

  define_templates :confirmation, [:user, :base_url, :confirmation_url, :opts]

  def confirmation_email(user, base_url, opts \\ []) do
    confirmation_url = Path.join(base_url, "/users/confirm?token=#{user.confirmation_token}")
    subject = if opts[:registration], do: "Welcome to Opencov", else: "Please confirm your email"
    %Mailman.Email{
      subject: subject,
      to: ["#{user.name} <#{user.unconfirmed_email}>"],
      text: confirmation_text(user, base_url, confirmation_url, opts),
      html: confirmation_html(user, base_url, confirmation_url, opts)
    }
  end
end
