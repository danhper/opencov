defmodule Librecov.Services.Projects do
  alias Librecov.Project
  alias Librecov.Repo
  alias Librecov.Build
  import Ecto.Query

  use EctoResource

  using_repo(Repo) do
    resource(Project)
  end

  def projects_for_repos([]), do: []

  def projects_for_repos(repos_ids) do
    from(p in Project, where: p.repo_id in ^repos_ids, order_by: [desc: p.updated_at])
  end

  def with_latest_build(elems) do
    elems
    |> Repo.preload(builds: from(b in Build, order_by: [desc: b.inserted_at], limit: 1))
  end

  def all(q), do: Repo.all(q)

  def get_project_by(opts) do
    Repo.get_by(Project, opts)
  end
end
