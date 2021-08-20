defmodule Librecov.Mixfile do
  use Mix.Project

  def project do
    [
      app: :librecov,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env:
        cli_env_for(:test, [
          "coveralls",
          "coveralls.detail",
          "coveralls.html",
          "coveralls.json",
          "coveralls.post"
        ])
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn key, acc -> Keyword.put(acc, :"#{key}", env) end)
  end

  def application do
    [mod: {Librecov, []}, extra_applications: [:logger, :crypto]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  defp deps do
    [
      {:joken, "~> 2.0"},
      {:stream_gzip, "~> 0.4"},
      {:comeonin, "~> 2.4"},
      {:gettext, "~> 0.11"},
      {:secure_random, "~> 0.2"},
      {:temp, "~> 0.4"},
      {:timex, "~> 3.4"},
      {:scrivener_ecto, "~> 2.7"},
      {:navigation_history, "~> 0.2"},
      {:ex_machina, "~> 2.7"},
      {:mailman, "~> 0.4"},
      {:eiconv, "~> 1.0"},
      {:scrivener_html, "~> 1.3"},
      {:seedex, "~> 0.3"},
      {:oauth2, "~> 0.7"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.10", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0", override: true},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:plug_cowboy, "~> 2.0"},
      {:ranch, "~> 1.8", override: true},
      {:meck, "~> 0.9", override: true},
      {:tesla, "~> 1.2"},
      {:poison, "~> 3.0"},
      {:ex_octocat, github: "yknx4/ex_octocat", tag: "v1.1.4"}
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
