defmodule Librecov.Services.Github.Checks do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Checks

  def finish_check(token, commit, owner, repo, coverage) do
    token
    |> Connection.new()
    |> Checks.checks_create(owner, repo,
      body: %{
        name: "Open Coverage",
        head_sha: commit,
        conclusion: "success",
        output: %{
          title: "Coverage at #{coverage}%",
          summary: "#{coverage}%"
        }
      }
    )
  end

  def create_check(token, commit, owner, repo) do
    token
    |> Connection.new()
    |> Checks.checks_create(owner, repo,
      body: %{
        name: "Open Coverage",
        head_sha: commit,
        output: %{
          title: "Waiting for tests to finish.",
          summary: "Waiting for tests to finish."
        }
      }
    )
  end
end
