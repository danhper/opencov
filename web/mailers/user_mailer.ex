defmodule Opencov.UserMailer do
  use Opencov.Web, :mailer

  define_templates :send_registration, [:user]

  def send_registration(user) do
    %Mailman.Email{
      subject: "Hello Mailman!",
      to: [user.email],
      text: send_registration_text(user),
      html: send_registration_html(user)
    }
  end
end
