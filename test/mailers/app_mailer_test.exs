defmodule Opencov.AppMailerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  alias Opencov.AppMailer

  @email %Mailman.Email{from: "noreply@example.com", to: ["user@example.com"]}

  test "adds verifying tls_options with SNI when TLS is used" do
    opts = AppMailer.smtp_options(relay: "smtp.gmail.com", tls: :always)
    tls = opts[:tls_options]
    assert tls[:verify] == :verify_peer
    assert tls[:server_name_indication] == ~c"smtp.gmail.com"
    assert is_list(tls[:cacerts]) and tls[:cacerts] != []
    refute opts[:sockopts]
  end

  test "user-provided tls_options take precedence" do
    opts = AppMailer.smtp_options(relay: "smtp.local", tls: :always, tls_options: [verify: :verify_none])
    assert opts[:tls_options][:verify] == :verify_none
  end

  test "passes TLS options as sockopts with implicit SSL" do
    opts = AppMailer.smtp_options(relay: "smtp.gmail.com", ssl: true, port: 465)
    assert opts[:sockopts][:server_name_indication] == ~c"smtp.gmail.com"
  end

  test "leaves options untouched without TLS" do
    opts = [relay: "localhost", tls: :never, ssl: false]
    assert AppMailer.smtp_options(opts) == opts
  end

  test "returns and logs an error when delivery fails (#32)" do
    smtp = [relay: "127.0.0.1", port: 1, tls: :never, auth: :never, retries: 0]
    log = capture_log(fn ->
      assert {:error, _} = AppMailer.deliver(@email, "Subject: x\r\n\r\nx", smtp)
    end)
    assert log =~ "Failed to send email to user@example.com"
  end
end
