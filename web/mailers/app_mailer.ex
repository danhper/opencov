defmodule Librecov.AppMailer do
  def send(email) do
    email = %{email | from: sender()}
    message = generate_message(email)
    Mailman.Adapter.deliver(mailman_config(), normalize_email(email), message)
  end

  defp generate_message(email) do
    Mailman.Render.render(email, %Mailman.EexComposeConfig{})
  end

  defp normalize_email(email) do
    %{email | from: extract_address(email.from), to: Enum.map(email.to, &extract_address/1)}
  end

  defp sender() do
    mail_config()[:sender]
  end

  defp mail_config do
    Application.get_env(:librecov, :email, [])
  end

  defp mailman_config() do
    if Mix.env() == :test do
      %Mailman.TestConfig{}
    else
      struct(Mailman.SmtpConfig, mail_config()[:smtp])
    end
  end

  defp extract_address(email) do
    case Regex.run(~r/.*?<(.*?)>/, email) do
      [_, extracted] -> extracted |> String.trim() |> String.downcase()
      _ -> email
    end
  end
end
