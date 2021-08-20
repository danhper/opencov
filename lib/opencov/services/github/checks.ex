defmodule Opencov.Services.Github.Checks do
  require Logger
  alias Opencov.Repo
  alias Opencov.Project
  alias Opencov.ProjectManager
  alias GitHubV3RESTAPI.Connection
  alias GitHubV3RESTAPI.Api.Checks
  alias Opencov.Services.GithubAuth

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
