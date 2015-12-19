defmodule Opencov.UserMailer do
  use Opencov.Web, :mailer

  define_templates :confirmation, [:user, :base_url, :confirmation_url, :invited]

  def confirmation_email(user, base_url, invited) do
    confirmation_url = Path.join(base_url, "/users/confirm?token=#{user.confirmation_token}")
    %Mailman.Email{
      subject: "Welcome to Opencov",
      to: ["#{user.name} <#{user.email}>"],
      text: confirmation_text(user, base_url, confirmation_url, invited),
      html: confirmation_html(user, base_url, confirmation_url, invited)
    }
  end
end
