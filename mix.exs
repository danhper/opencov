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
     extra_applications: [:logger, :eex]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.2"},
     {:phoenix_ecto, "~> 3.2"},
     {:gen_smtp, "~> 1.1"},
     {:postgrex, "~> 0.13"},
     {:phoenix_html, "~> 2.6"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 2.7"},
     {:plug_cowboy, "~> 2.0"},
     {:exgravatar, "~> 2.0"},
     {:secure_random, "~> 0.2"},
     {:temp, "~> 0.4"},
     {:timex, "~> 3.1"},
     {:timex_ecto, "~> 3.1"},
     {:scrivener_ecto, "~> 1.0"},
     {:basic_auth, "~> 2.0"},
     {:navigation_history, "~> 0.2"},
     {:ex_machina, "~> 2.0"},
     {:mailman, github: "mailman-elixir/mailman"},
     {:scrivener_html, "~> 1.3"},
     {:secure_password, "~> 0.4"},
     {:seedex, "~> 0.1.3"},
     {:jason, "~> 1.2"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:excoveralls, "~> 0.6", only: :test},
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
