defmodule Opencov.CreateBuildService do
  alias Opencov.Build
  alias Opencov.Repo
  import Ecto.Changeset

  def make_changeset(project, params \\ :empty) do
    Ecto.build_assoc(project, :builds)
    |> Build.changeset(params)
    |> finalize_changeset(project)
  end

  def create_build(project, attrs \\ %{}),
    do: make_changeset(project, attrs) |> Repo.insert

  def create_build!(project, attrs \\ %{}),
    do: make_changeset(project, attrs) |> Repo.insert!

  defp finalize_changeset(%Ecto.Changeset{valid?: false} = changeset, _project),
    do: changeset
  defp finalize_changeset(changeset, project) do
    changeset
    |> prepare_changes(&add_previous_values(&1, project))
  end

  defp add_previous_values(changeset, project) do
    if previous_build = search_previous_build(changeset, project) do
      change(changeset, %{previous_build_id: previous_build.id, previous_coverage: previous_build.coverage})
    else
      changeset
    end
  end

  defp search_previous_build(changeset, project) do
    Build.previous(project.id,
                   get_change(changeset, :build_number),
                   get_change(changeset, :branch))
    |> Opencov.Repo.one
  end
end
