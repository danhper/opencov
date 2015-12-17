defmodule AppMailer do
  def send(email, opts \\ []) do
    email = %{email | from: opts[:from] || default_from}
    Mailman.deliver(email, config)
  end

  def config do
    %Mailman.Context{
      config:   %Mailman.LocalSmtpConfig{
        port: 1234
      },
      composer: %Mailman.EexComposeConfig{}
    }
  end

  defp default_from do
    app_config[:sender]
  end

  defp app_config do
    Application.get_env(:opencov, :email, [])
  end
end
