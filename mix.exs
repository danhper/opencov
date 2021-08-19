defmodule Opencov.Mixfile do
  use Mix.Project

  def project do
    [
      app: :opencov,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  def application do
    [mod: {Opencov, []}, extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.2"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, "~> 0.15"},
      {:phoenix_html, "~> 2.6"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:exgravatar, "~> 2.0"},
      {:secure_random, "~> 0.2"},
      {:temp, "~> 0.4"},
      {:timex, "~> 3.4"},
      {:scrivener_ecto, "~> 2.7"},
      {:basic_auth, "~> 2.0"},
      {:navigation_history, "~> 0.2"},
      {:ex_machina, "~> 2.7"},
      {:mailman, "~> 0.4"},
      {:eiconv, "~> 1.0"},
      {:scrivener_html, "~> 1.3"},
      {:seedex, "~> 0.3"},
      {:oauth2, "~> 0.7"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:excoveralls, "~> 0.6", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "seedex.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.compile": [&compile_assets/1, "phx.digest"]
    ]
  end

  defp compile_assets(_) do
    System.cmd(Path.expand("node_modules/.bin/webpack", __DIR__), ["-p"],
      into: IO.stream(:stdio, :line)
    )
  end
end
