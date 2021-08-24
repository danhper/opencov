defmodule Librecov.Services.Github.Repos do
  require Logger

  alias ExOctocat.Connection
  alias ExOctocat.Api.Repos
  alias Librecov.Services.Github.AuthData

  def available_repos(user_token, params \\ []) do
    user_token
    |> Connection.new()
    |> Repos.repos_list_for_authenticated_user(params)
  end

  def repo(%AuthData{token: token, owner: owner, repo: repo}) do
    token
    |> Connection.new()
    |> Repos.repos_get(owner, repo)
  end
end
