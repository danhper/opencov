defmodule Opencov.Build do
  use Opencov.Web, :model

  @git_defaults %{"branch" => nil, "head" => %{"id" => nil, "committer_name" => nil,
                                               "committer_email" => nil, "message" => nil }}

  import Ecto.Query

  schema "builds" do
    field :build_number, :integer
    field :previous_build_id, :integer
    field :coverage, :float, default: 0.0
    field :completed, :boolean, default: true
    field :previous_coverage, :float
    field :build_started_at, Ecto.DateTime

    field :commit_sha, :string
    field :committer_name, :string
    field :committer_email, :string
    field :commit_message, :string
    field :branch, :string, default: ""

    field :service_name, :string
    field :service_job_id, :string
    field :service_job_pull_request, :string

    belongs_to :project, Opencov.Project
    has_many :jobs, Opencov.Job
    has_one :previous_build, Opencov.Build, foreign_key: :previous_build_id

    timestamps
  end


  def previous(project_id, build_number, nil),
    do: previous(project_id, build_number, "")
  def previous(project_id, build_number, branch) do
    query_for_project(project_id)
    |> where([b], b.build_number < ^build_number and b.branch == ^branch)
    |> order_by_build_number
    |> first
  end

  def current_for_project(query, project) do
    query |> for_project(project.id) |> where([b], not b.completed)
  end

  def last_for_project(query, project) do
    query |> for_project(project.id) |> order_by_build_number |> first
  end

  def query_for_project(project_id) do
    for_project(Opencov.Build, project_id)
  end

  def for_project(query, project_id) do
    query |> where([b], b.project_id == ^project_id)
  end

  def order_by_build_number(query) do
    query |> order_by([b], [desc: b.build_number])
  end

  def normalize_params(params) when is_map(params) do
    {git_info, params} = Map.pop(params, "git")
    Map.merge(params, git_params(git_info))
  end
  def normalize_params(params), do: params

  defp git_params(nil), do: %{}
  defp git_params(params) do
    params = Map.merge(@git_defaults, params)
    params = Map.put(params, "head", Map.merge(@git_defaults["head"], params["head"]))
    %{
      "branch" => branch,
      "head" => %{
        "id" => commit_sha,
        "committer_name" => committer_name,
        "committer_email" => committer_email,
        "message" => commit_message
      }
    } = params
    result = %{"branch" => branch || "", "commit_sha" => commit_sha, "committer_name" => committer_name,
        "committer_email" => committer_email, "commit_message" => commit_message}
    for {k, v} <- result, into: %{} do
      v = if is_nil(v), do: v, else: String.strip(v)
      {k, v}
    end
  end

  def for_commit(project, %{"branch" => branch, "head" => %{"id" => sha}})
      when is_binary(branch) and is_binary(sha) and byte_size(branch) > 0 and byte_size(sha) > 0 do
    Opencov.Build
      |> for_project(project.id)
      |> where([b], b.branch == ^branch and b.commit_sha == ^sha)
  end
  def for_commit(_, _), do: nil

  def compute_coverage(build) do
    build.jobs
    |> Enum.map(fn j -> j.coverage end)
    |> Enum.reject(fn n -> is_nil(n) or n == 0 end)
    |> Enum.min
  end
end
