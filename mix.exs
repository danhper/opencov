defmodule Opencov.Mixfile do
  use Mix.Project

  def project do
    [app: :opencov,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     test_coverage: [tool: ExCoveralls],
     deps: deps]
  end

  def application do
    [mod: {Opencov, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :tzdata, :secure_password]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.1"},
     {:phoenix_ecto, "~> 1.2"},
     {:postgrex, "~> 0.10.0"},
     {:phoenix_html, "~> 2.1"},
     {:cowboy, "~> 1.0"},
     {:exgravatar, "~> 2.0"},
     {:secure_random, "~> 0.2"},
     {:temp, "~> 0.2.5"},
     {:timex, "~> 1.0.0"},
     {:timex_ecto, "~> 0.7.0"},
     {:scrivener, "~> 1.0"},
     {:plug_basic_auth, "~> 1.0"},
     {:navigation_history, "~> 0.2"},
     {:ex_machina, github: "tuvistavie/ex_machina", branch: "allow-changset-customization"},
     {:mailman, "~> 0.1.0"},
     {:eiconv, github: "zotonic/eiconv"},
     {:scrivener_html, github: "tuvistavie/scrivener_html", branch: "elixir-1.2-support"},
     {:secure_password, "~> 0.3"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:excoveralls, "~> 0.4.3", only: :test},
     {:mock, "~> 0.1.1", only: :test}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
