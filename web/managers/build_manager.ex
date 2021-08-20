defmodule Librecov.BuildManager do
  use Librecov.Web, :manager

  alias Librecov.Build
  import Librecov.Build

  @required_fields ~w(build_number)a
  @optional_fields ~w(commit_sha commit_message committer_name committer_email branch
                      service_name service_job_id service_job_pull_request project_id completed)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(normalize_params(params), @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> set_build_started_at
    |> prepare_changes(&add_previous_values/1)
  end

  def create_from_json!(project, params) do
    params = Map.merge(params, info_for(project, params))
    build = Ecto.build_assoc(project, :builds)
    Repo.insert!(changeset(build, params))
  end

  def get_or_create!(project, params) do
    current_build = current_for_project(Build, project) |> Repo.first()
    git_params = Map.get(params, "git", %{})

    if build = current_build || Repo.first(for_commit(project, git_params)),
      do: build,
      else: create_from_json!(project, params)
  end

  def update_coverage(build) do
    coverage = build |> Repo.preload(:jobs) |> compute_coverage
    build = Repo.update!(change(build, coverage: coverage))

    Librecov.ProjectManager.update_coverage(Repo.preload(build, :project).project)

    build
  end

  defp set_build_started_at(changeset) do
    if get_change(changeset, :build_started_at),
      do: changeset,
      else: put_change(changeset, :build_started_at, DateTime.utc_now())
  end

  # TODO: fetch build/job numbers from CI APIs
  # def info_for(_project, %{"service_name" => "travis-ci"}), do: %{"build_number" => 1, "job_number" => 1}
  def info_for(project, params), do: fallback_info_for(project, params)

  defp fallback_info_for(project, _params) do
    build = query_for_project(project.id) |> order_by_build_number |> Repo.first()
    if build, do: %{"build_number" => build.build_number + 1}, else: %{"build_number" => 1}
  end

  defp add_previous_values(changeset) do
    project_id = changeset.data.project_id || get_change(changeset, :project_id)

    if previous_build = search_previous_build(changeset, project_id) do
      change(changeset, %{
        previous_build_id: previous_build.id,
        previous_coverage: previous_build.coverage
      })
    else
      changeset
    end
  end

  defp search_previous_build(changeset, project_id) do
    Build.previous(
      project_id,
      get_change(changeset, :build_number),
      get_change(changeset, :branch)
    )
    |> Librecov.Repo.first()
  end
end
