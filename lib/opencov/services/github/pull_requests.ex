defmodule Librecov.Services.Github.PullRequests do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Pulls
  alias Librecov.Services.Github.AuthData

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
