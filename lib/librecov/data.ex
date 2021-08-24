defmodule Librecov.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Librecov.Repo

  alias Librecov.Data.Repository
  alias Librecov.User.Authorization
  alias Librecov.Services.Github.Repos
  alias Librecov.Services.Github.AuthData

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories(%{provider: "github", token: token, refresh_token: _refresh_token}) do
    {:ok, repos} = Repos.available_repos(token, sort: "pushed")
    repos
  end

  @doc """
  Gets a single repository.

  Raises if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

  """
  def get_repository!(
        %{provider: "github", token: token, refresh_token: _refresh_token},
        owner,
        repo
      ) do
    {:ok, repo} = Repos.repo(%AuthData{token: token, owner: owner, repo: repo})
    repo
  end

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, ...}

  """
  def create_repository(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, ...}

  """
  def update_repository(repository, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, ...}

  """
  def delete_repository(repository) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Todo{...}

  """
  def change_repository(repository, _attrs \\ %{}) do
    raise "TODO"
  end
end
