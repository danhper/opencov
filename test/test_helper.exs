ExUnit.start

Application.ensure_all_started(:ex_machina)

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Code.require_file(Path.join([__DIR__, "..", "priv", "repo", "seeds.exs"]))
Ecto.Adapters.SQL.Sandbox.mode(Opencov.Repo, :manual)
