defmodule Opencov.Mixfile do
  use Mix.Project

  def project do
    [
      app: :opencov,
      version: "0.0.1",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  def application do
    [mod: {Opencov, []}, extra_applications: [:logger, :eex]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.8.0"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_ecto, "~> 4.7"},
      {:ecto_sql, "~> 3.13"},
      {:gen_smtp, "~> 1.3", override: true},
      {:postgrex, "~> 0.22"},
      {:phoenix_html, "~> 4.3"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 2.7"},
      {:plug_cowboy, "~> 2.0"},
      {:exgravatar, "~> 2.0"},
      {:secure_random, "~> 0.2"},
      {:temp, "~> 0.4"},
      {:timex, "~> 3.1"},
      {:scrivener_ecto, "~> 3.0"},
      {:navigation_history, "~> 0.2"},
      {:ex_machina, "~> 2.0"},
      {:mailman, github: "mailman-elixir/mailman"},
      {:bcrypt_elixir, "~> 3.3"},
      seedex_dep(),
      {:jason, "~> 1.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:mix_test_watch, "~> 1.3", only: :dev},
      {:excoveralls, "~> 0.6", only: :test},
      {:mock, "~> 0.3.9", only: :test},
      {:meck, "~> 1.1", only: :test, override: true}
    ]
  end

  # Allows validating a new Seedex release against this app before publishing it.
  defp seedex_dep do
    if path = System.get_env("SEEDEX_PATH") do
      {:seedex, path: path}
    else
      {:seedex, "~> 0.4.0"}
    end
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "seedex.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.compile": [&compile_assets/1, "phx.digest"]
    ]
  end

  defp compile_assets(_) do
    {_, status} =
      System.cmd(Path.expand("node_modules/.bin/webpack", __DIR__), ["-p"],
        into: IO.stream(:stdio, :line)
      )

    if status != 0, do: Mix.raise("Asset compilation failed")
  end
end
