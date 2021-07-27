defmodule Opencov.Mixfile do
  use Mix.Project

  def project do
    [app: :opencov,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     test_coverage: [tool: ExCoveralls],
     deps: deps()]
  end

  def application do
    [mod: {Opencov, []},
     extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.4"},
     {:phoenix_ecto, "~> 3.6"},
     {:phoenix_pubsub, "~> 1.1"},
     {:postgrex, "~> 0.13"},
     {:phoenix_html, "2.14.3"},
     {:gettext, "~> 0.11"},
     {:exgravatar, "~> 2.0"},
     {:secure_random, "~> 0.2"},
     {:temp, "~> 0.4"},
     {:timex, "~> 3.7"},
     {:timex_ecto, "~> 3.4"},
     {:scrivener_ecto, "~> 1.0"},
     {:basic_auth, "~> 2.0"},
     {:navigation_history, "~> 0.2"},
     {:ex_machina, "2.7.0"},
     {:mailman, "0.4.2"},
     {:eiconv, "~> 1.0"},
     {:scrivener_html, "~> 1.8"},
     {:secure_password, "~> 0.4"},
     {:seedex, "~> 0.1.3"},
     {:poison, "~> 3.1"},
     {:plug, "~> 1.6"},
     {:plug_cowboy, "~> 2.0"},
    #  {:esaml, "~> 4.2"},
    #  {:samly, "1.0.0"},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:excoveralls, "~> 0.6", only: :test},
    #  {:poison, "~> 4.0"},
      # {:esaml, "~> 4.2"},
      {:sweet_xml, "~> 0.6.6"},
      {:openid_connect, "~> 0.2.2"},
      {:phoenix_live_reload, "~> 1.3"},
      # {:guardian, "~> 2.0"}
      {:mariaex, "~> 0.8.2"},
     {:mock, "~> 0.3", only: :test}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "seedex.seed"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "assets.compile": [&compile_assets/1, "phx.digest"]]
  end

  defp compile_assets(_) do
    System.cmd(Path.expand("node_modules/.bin/webpack", __DIR__), ["-p"], into: IO.stream(:stdio, :line))
  end
end
