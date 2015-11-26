defmodule Opencov.File do
  use Opencov.Web, :model

  import Ecto.Query

  defimpl Poison.Encoder, for: Opencov.File do
    def encode(model, opts) do
      model
        |> Map.take([:name, :source])
        |> Dict.put(:coverage, model.coverage_lines)
        |> Poison.Encoder.encode(opts)
    end
  end

  alias Opencov.Job

  schema "files" do
    field :name, :string
    field :source, :string
    field :coverage, :float
    field :previous_coverage, :float
    field :coverage_lines, Opencov.Types.JSON

    belongs_to :job, Job
    belongs_to :previous_file, Opencov.File

    timestamps
  end

  before_insert :generate_coverage
  before_insert :set_previous_file

  @required_fields ~w(name source coverage_lines job_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(normalize_params(params), @required_fields, @optional_fields)
  end

  def for_job(job), do: for_job(base_query, job)

  def for_job(query, jobs) when is_list(jobs), do: query |> where([f], f.job_id in ^jobs)
  def for_job(query, %Opencov.Job{id: job_id}), do: for_job(query, job_id)
  def for_job(query, job_id), do: query |> where([f], f.job_id == ^job_id)

  def with_filters(query, [filter|rest]), do: with_filters(with_filter(query, filter), rest)
  def with_filters(query, []), do: query

  def with_filter(query, "cov_changed") do
    query |> where([f], f.coverage != f.previous_coverage)
  end
  def with_filter(query, "changed") do
    query
    |> join(:left, [f], of in assoc(f, :previous_file))
    |> where([f, of], f.source != of.source or is_nil(of.source))
  end
  def with_filter(query, "covered"), do: query |> where([f], f.coverage > 0.0)
  def with_filter(query, "unperfect"), do: query |> where([f], f.coverage < 100.0)
  def with_filter(query, _), do: query

  def base_query do
    from f in Opencov.File, select: f
  end

  def query_with_name(query, name) do
    query |> where([f], f.name == ^name)
  end

  def order_by_coverage(query, order \\ :desc) do
    query |> order_by([f], [{^order, f.coverage}])
  end

  defp normalize_params(%{"coverage" => coverage} = params) when is_list(coverage) do
    {lines, params} = Dict.pop(params, "coverage")
    Dict.put(params, "coverage_lines", lines)
  end
  defp normalize_params(params), do: params

  defp generate_coverage(changeset) do
    lines = get_change(changeset, :coverage_lines)
    if lines do
      put_change(changeset, :coverage, compute_coverage(lines))
    else
      changeset
    end
  end

  defp set_previous_file(changeset) do
    job = Opencov.Repo.get(Opencov.Job, get_change(changeset, :job_id))
    if is_nil(job) or is_nil(job.previous_job_id) do
      changeset
    else
      {job_id, name} = {job.previous_job_id, changeset.changes.name}
      if file = find_previous_file(job_id, name) do
        change(changeset, previous_file_id: file.id, previous_coverage: file.coverage)
      else
        changeset
      end
    end
  end

  defp find_previous_file(previous_job_id, name) do
    Opencov.Repo.one(base_query |> for_job(previous_job_id) |> query_with_name(name))
  end

  def compute_coverage(lines) do
    relevant_count = relevant_lines_count(lines)
    if relevant_count == 0, do: 0.0, else: covered_lines_count(lines) * 100 / relevant_count
  end

  def relevant_lines_count(lines) do
    lines |> Enum.reject(fn n -> is_nil(n) end) |> Enum.count
  end

  def covered_lines_count(lines) do
    lines |> Enum.reject(fn n -> is_nil(n) or n == 0 end) |> Enum.count
  end
end
