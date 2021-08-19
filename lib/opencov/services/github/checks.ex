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
          title: "Code Coverage",
          summary: "#{coverage}%"
        }
      }
    )
    |> IO.inspect()
  end

  def create_check(token, commit, owner, repo) do
    token
    |> Connection.new()
    |> Checks.checks_create(owner, repo,
      body: %{
        name: "Open Coverage",
        head_sha: commit,
        output: %{
          title: "Code Coverage",
          summary: "Waiting for tests to finish."
        }
      }
    )
    |> IO.inspect()
  end

  def install(repo_id, name, base_url, user_id) do
    with {:ok, %Project{} = new_project} <-
           Repo.insert(
             ProjectManager.changeset(%Project{}, %{
               name: name,
               base_url: base_url,
               current_coverage: 0.0,
               token: "oc_#{SecureRandom.urlsafe_base64(12)}",
               user_id: user_id,
               repo_id: "github_#{repo_id}"
             })
           ) do
      Logger.info("Installed Repo #{name}")
      new_project
    end
  end
end
