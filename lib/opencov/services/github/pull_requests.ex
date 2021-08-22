defmodule Librecov.Services.Github.PullRequests do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Pulls
  alias Librecov.Services.Github.AuthData
  alias Librecov.Build

  def find_prs_for_build(auth, %Build{service_job_pull_request: pr})
      when is_binary(pr) and pr != "" do
    with {:ok, pr} <- get_pr(auth, pr) do
      {:ok, [pr]}
    end
  end

  def find_prs_for_build(auth, %Build{branch: branch}), do: find_prs_for_branch(auth, branch)

  def get_pr(%AuthData{token: token, owner: owner, repo: repo}, pr) do
    token
    |> Connection.new()
    |> Pulls.pulls_get(owner, repo, pr)
  end

  def find_prs_for_branch(_, branch)
      when branch in [nil, ""],
      do: {:ok, []}

  def find_prs_for_branch(%AuthData{token: token, owner: owner, repo: repo}, branch) do
    token
    |> Connection.new()
    |> Pulls.pulls_list(owner, repo, state: "open", sort: "updated", head: "#{owner}:#{branch}")
  end
end
