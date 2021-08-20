defmodule Librecov.GithubService do
  require Logger
  alias Librecov.Repo
  alias Librecov.Project
  alias Librecov.ProjectManager
  alias Librecov.Services.Github.Auth
  alias Librecov.Services.Github.Checks

  def handle("pull_request", payload) do
    handle_pr(payload["action"], payload)
    install(payload["repository"])
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

  defp install(%{"id" => repo_id, "full_name" => name, "html_url" => base_url}) do
    with {:ok, %Project{}} <-
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
