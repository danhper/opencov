defmodule ConfigServerTest do
  use ExUnit.Case

  alias Opencov.ConfigServer

  defp cleanup do
    Mix.Config.persist(opencov: [runtime: []])
    File.rm_rf!(Application.get_env(:opencov, :runtime_config_path))
  end

  setup do
    cleanup
    on_exit &cleanup/0
  end

  test "set key value" do
    refute Application.get_env(:opencov, :runtime)[:foo]
    ConfigServer.set(:foo, "bar")
    :timer.sleep(5)
    assert Application.get_env(:opencov, :runtime)[:foo] == "bar"
    config_file = Application.get_env(:opencov, :runtime_config_path)
    assert File.exists?(config_file)
    assert Mix.Config.read!(config_file)[:opencov][:runtime] == Application.get_env(:opencov, :runtime)
  end

  test "set keyword" do
    refute Application.get_env(:opencov, :runtime)[:foo]
    refute Application.get_env(:opencov, :runtime)[:bar]
    ConfigServer.set([foo: "bar", bar: "baz"])
    :timer.sleep(5)
    assert Application.get_env(:opencov, :runtime)[:foo] == "bar"
    assert Application.get_env(:opencov, :runtime)[:bar] == "baz"
  end
end
