defmodule Librecov.Queries.BuildQueries do
  import Ecto.Query
  alias Librecov.Build

  def latest_for_project_commit(project_id, commit) do
    query_for_project(project_id)
    |> where([b], b.commit == ^commit)
    |> latest()
  end

  def latest_for_project_branch(project_id, branch),
    do: latest_for_project_branches(project_id, [branch])

  def latest_for_project_branches(project_id, branches) do
    query_for_project(project_id)
    |> latest()
    |> where([b], b.branch in ^branches)
  end

  def query_for_project(project_id) do
    for_project(Build, project_id)
  end

  def for_project(query, project_id) do
    query |> where([b], b.project_id == ^project_id)
  end

  def latest(query) do
    query
    |> order_by([b], desc: b.created_at)
    |> limit(1)
  end

  def only_completed(query), do: query |> where([b], completed: true)
end
