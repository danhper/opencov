defmodule Opencov.Helpers.ConnHelpersTest do
  use ExUnit.Case

  alias Opencov.Helpers.ConnHelpers

  test "base_url returns correct http url" do
    conn = %Plug.Conn{scheme: "http", host: "example.com", port: 80}
    assert ConnHelpers.base_url(conn) == "http://example.com"
  end

  test "base_url returns correct https url" do
    conn = %Plug.Conn{scheme: "https", host: "example.com", port: 443}
    assert ConnHelpers.base_url(conn) == "https://example.com"
  end

  test "base_url adds non standard ports" do
    conn = %Plug.Conn{scheme: "http", host: "example.com", port: 8080}
    assert ConnHelpers.base_url(conn) == "http://example.com:8080"
  end

  test "returns overriden base url if present" do
    conn = %Plug.Conn{scheme: "http", host: "example.com", port: 8080}
    Mix.Config.persist([opencov: [base_url: "http://foo.example.com"]])
    assert ConnHelpers.base_url(conn) == "http://foo.example.com"
    Mix.Config.persist([opencov: [base_url: nil]])
  end
end
