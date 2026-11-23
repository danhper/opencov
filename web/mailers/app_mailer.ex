defmodule Opencov.AppMailer do
  require Logger

  def send(email) do
    email = %{email | from: sender()}
    message = generate_message(email)
    email = normalize_email(email)

    if Mix.env == :test do
      Mailman.Adapter.deliver(%Mailman.TestConfig{}, email, message)
    else
      deliver(email, message, mail_config()[:smtp] || [])
    end
  end

  @doc """
  Delivers a rendered message over SMTP using `gen_smtp`.

  Mailman's SMTP adapter only forwards a fixed set of options, which makes it
  impossible to pass `tls_options`. Without them, TLS fails on recent OTP
  versions (peer verification is on by default but no CA certificates are
  given), so we call `gen_smtp` directly. Failures are logged and returned.
  """
  def deliver(email, message, smtp_opts) do
    case :gen_smtp_client.send_blocking({email.from, email.to, message}, smtp_options(smtp_opts)) do
      {:error, type, details} -> log_failure(email, {type, details})
      {:error, reason} -> log_failure(email, reason)
      receipt -> {:ok, receipt}
    end
  end

  @doc false
  def smtp_options(opts) do
    secure? = Keyword.get(opts, :ssl, false) or Keyword.get(opts, :tls, :never) != :never
    if secure? do
      tls_options = Keyword.merge(default_tls_options(opts[:relay]), Keyword.get(opts, :tls_options, []))
      opts = Keyword.put(opts, :tls_options, tls_options)
      # with `ssl: true`, gen_smtp connects with `sockopts` rather than `tls_options`
      if opts[:ssl], do: Keyword.update(opts, :sockopts, tls_options, &(tls_options ++ &1)), else: opts
    else
      opts
    end
  end

  defp default_tls_options(relay) do
    [
      verify: :verify_peer,
      cacerts: :public_key.cacerts_get(),
      server_name_indication: to_charlist(relay || ""),
      depth: 10,
      customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]
    ]
  end

  defp log_failure(email, reason) do
    Logger.error("Failed to send email to #{Enum.join(email.to, ", ")}: #{inspect(reason)}")
    {:error, reason}
  end

  defp generate_message(email) do
    Mailman.Render.render(email, %Mailman.EexComposeConfig{})
  end

  defp normalize_email(email) do
    %{email | from: extract_address(email.from),
              to: Enum.map(email.to, &extract_address/1)}
  end

  defp sender() do
    mail_config()[:sender]
  end

  defp mail_config do
    Application.get_env(:opencov, :email, [])
  end

  defp extract_address(email) do
    case Regex.run(~r/.*?<(.*?)>/, email) do
      [_, extracted] -> extracted |> String.trim() |> String.downcase()
      _ -> email
    end
  end
end
