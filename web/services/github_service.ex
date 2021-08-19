defmodule Opencov.GithubService do
  require Logger
  alias Opencov.Repo
  alias Opencov.Project
  alias Opencov.ProjectManager
  alias GitHubV3RESTAPI.Connection
  alias GitHubV3RESTAPI.Api.Checks

  def handle("push", payload) do
    install(payload["repository"])
    IO.inspect(payload)
    pr = payload["pull_request"]
    IO.inspect(pr)
  end

  def handle("pull_request", payload) do
    IO.inspect(payload)
    pr = payload["pull_request"]
    IO.inspect(pr)
  end

  def handle(event, _payload) do
    Logger.warn("Unhandled event: #{event}")
  end

  defp create_check(commit, %{"name" => repo, "owner" => %{"name" => owner}}) do
    Connection.new()
    |> Checks.checks_create(owner, repo, %{
      name: "Open Coverage",
      head_sha: commit
    })
  end

  defp install(%{"id" => repo_id, "full_name" => name, "html_url" => base_url}) do
    with {:ok, %Project{} = new_project} =
           Repo.insert(
             ProjectManager.changeset(%Project{}, %{
               name: name,
               base_url: base_url,
               current_coverage: 0.0,
               token: "oc_#{SecureRandom.urlsafe_base64(12)}",
               user_id: 1,
               repo_id: "github_#{repo_id}"
             })
           ) do
      Logger.info("Installed Repo #{name}")
    end
  end
end
