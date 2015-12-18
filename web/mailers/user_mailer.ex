defmodule Opencov.UserMailer do
  use Opencov.Web, :mailer

  define_templates :registration, [:user]

  def registration_email(user) do
    %Mailman.Email{
      subject: "Welcome to Opencov",
      to: ["#{user.name} <#{user.email}>"],
      text: registration_text(user),
      html: registration_html(user)
    }
  end
end
