defmodule Opencov.Build do
  use Opencov.Web, :model

  import Ecto.Query

  schema "builds" do
    field :build_number, :integer
    field :previous_build_id, :integer
    field :coverage, :float, default: 0.0
    field :completed, :boolean, default: true
    field :previous_coverage, :float
    field :build_started_at, Ecto.DateTime

    field :commit_sha, :string
    field :author_name, :string
    field :author_email, :string
    field :commit_message, :string
    field :branch, :string

    field :service_name, :string
    field :service_job_id, :string
    field :service_job_pull_request, :string

    belongs_to :project, Opencov.Project
    has_many :jobs, Opencov.Job
    has_one :previous_build, Opencov.Build, foreign_key: :previous_build_id

    timestamps
  end

  @required_fields ~w(build_number project_id)
  @optional_fields ~w(commit_sha commit_message author_name author_email branch
                      service_name service_job_id service_job_pull_request)

  before_insert :set_build_started_at
  before_insert :set_previous_values
  after_update :update_project_coverage

  def changeset(model, params \\ :empty) do
    model
    |> cast(normalize_params(params), @required_fields, @optional_fields)
  end

  # TODO: fetch build/job numbers from CI APIs
  # def info_for(_project, %{"service_name" => "travis-ci"}), do: %{"build_number" => 1, "job_number" => 1}
  def info_for(project, params), do: fallback_info_for(project, params)

  defp fallback_info_for(project, _params) do
    build = Opencov.Repo.one(query_for_project(project.id) |> order_by_build_number |> first)
    if build, do: %{"build_number" => build.build_number + 1}, else: %{"build_number" => 1}
  end

  defp set_build_started_at(changeset) do
    if get_change(changeset, :build_started_at), do: changeset,
    else: put_change(changeset, :build_started_at, Ecto.DateTime.utc)
  end

  defp set_previous_values(changeset) do
    {project_id, build_number} = {get_change(changeset, :project_id), get_change(changeset, :build_number)}
    previous_build = search_previous_build(project_id, build_number)
    if previous_build do
      change(changeset, %{previous_build_id: previous_build.id, previous_coverage: previous_build.coverage})
    else
      changeset
    end
  end

  defp search_previous_build(project_id, build_number) do
    query = query_for_project(project_id)
              |> where([b], b.build_number < ^build_number)
              |> order_by_build_number
              |> first
    Opencov.Repo.one(query)
  end

  def current_for_project(project) do
    Opencov.Repo.one(base_query |> for_project(project.id) |> where([b], not b.completed))
  end

  def last_for_project(project) do
    Opencov.Repo.one(base_query |> for_project(project.id) |> order_by_build_number |> first)
  end

  def base_query do
    from b in Opencov.Build, select: b
  end

  def first(query) do
    query |> limit([b], 1)
  end

  def query_for_project(project_id) do
    base_query |> for_project(project_id)
  end

  def for_project(query, project_id) do
    query |> where([b], b.project_id == ^project_id)
  end

  def order_by_build_number(query) do
    query |> order_by([b], [desc: b.build_number])
  end

  defp normalize_params(params) when is_map(params) do
    {git_info, params} = Dict.pop(params, "git")
    Dict.merge(params, git_params(git_info))
  end
  defp normalize_params(params), do: params

  defp git_params(%{
    "branch" => branch,
    "head" => %{
      "id" => commit_sha,
      "author_name" => author_name,
      "author_email" => author_email,
      "message" => commit_message
      }
    }) do
      %{"branch" => branch, "commit_sha" => commit_sha, "author_name" => author_name,
        "author_email" => author_email, "commit_message" => commit_message}
  end
  defp git_params(_), do: %{}

  def get_or_create!(project, params) do
    if build = current_for_project(project) do
      build
    else
      create_from_json!(project, params)
    end
  end

  def create_from_json!(project, params) do
    params = Dict.merge(params, info_for(project, params))
    build = Ecto.Model.build(project, :builds)
    Opencov.Repo.insert! changeset(build, params)
  end

  def update_coverage(build) do
    Opencov.Repo.update! %{build | coverage: compute_coverage(build)}
  end

  def compute_coverage(build) do
    Opencov.Repo.preload(build, :jobs).jobs
      |> Enum.map(fn j -> j.coverage end)
      |> Enum.reject(fn n -> is_nil(n) or n == 0 end)
      |> Enum.min
  end

  defp update_project_coverage(changeset) do
    if Dict.has_key?(changeset.changes, :coverage) do
      Opencov.Project.update_coverage(Opencov.Repo.preload(changeset.model, :project).project)
    end
    changeset
  end
end
