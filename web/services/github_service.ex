defmodule Opencov.GithubService do
  require Logger
  alias Opencov.Repo
  alias Opencov.Project
  alias Opencov.ProjectManager
  alias Opencov.Services.Github.Auth
  alias Opencov.Services.Github.Checks

  def handle("push", payload) do
    install(payload["repository"])
    IO.inspect(payload)
    pr = payload["pull_request"]
    IO.inspect(pr)
  end

  def handle("pull_request", payload) do
    handle_pr(payload["action"], payload)
  end

  def handle(event, _payload) do
    Logger.warn("Unhandled event: #{event}")
  end

  def handle_pr("synchronize", %{"after" => commit, "repository" => repo}) do
    with %{"name" => repo, "owner" => %{"login" => owner}} <- repo,
         {:ok, token} <- Auth.login_token(owner) do
      Checks.create_check(token, commit, owner, repo)
    end
  end

  def handle_pr(event, _payload) do
    Logger.warn("Unhandled pr event: #{event}")
  end

  def finish_check(commit, owner, repo) do
    with {:ok, token} <-
           owner
           |> Auth.login_token() do
      token
      |> Connection.new()
      |> Checks.checks_create(owner, repo,
        body: %{
          name: "Open Coverage",
          head_sha: commit,
          conclusion: "success"
        }
      )
      |> IO.inspect()
    end
  end

  defp install(%{"id" => repo_id, "full_name" => name, "html_url" => base_url}) do
    with {:ok, %Project{} = new_project} <-
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
