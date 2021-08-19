ExUnit.start()

Application.ensure_all_started(:ex_machina)

Mix.Task.run("ecto.create", ["--quiet"])
Mix.Task.run("ecto.migrate", ["--quiet"])
Mix.Task.run("seedex.seed")
Ecto.Adapters.SQL.Sandbox.mode(Opencov.Repo, :manual)
