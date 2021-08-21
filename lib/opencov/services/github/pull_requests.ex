defmodule Librecov.Services.Github.PullRequests do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Pulls

  def find_prs_for_branch(token, owner, repo, branch) do
    token
    |> Connection.new()
    |> Pulls.pulls_list(owner, repo, state: "open", sort: "updated", head: "#{owner}:#{branch}")
  end
end
