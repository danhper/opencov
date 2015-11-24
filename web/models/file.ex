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
    field :previous_file_id, :integer
    field :previous_coverage, :float
    field :coverage_lines, Opencov.Types.JSON

    belongs_to :job, Job
    has_one :previous_file, Opencov.File, foreign_key: :previous_file_id

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

  def for_job(job_id) do
    unless is_integer(job_id), do: job_id = job_id.id
    Opencov.Repo.all(base_query |> query_for_job(job_id) |> order_by_coverage)
  end

  def base_query do
    from f in Opencov.File, select: f
  end

  def query_with_name(query, name) do
    query |> where([f], f.name == ^name)
  end

  def query_for_job(query, job_id) do
    query |> where([f], f.job_id == ^job_id)
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
    Opencov.Repo.one(base_query |> query_for_job(previous_job_id) |> query_with_name(name))
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
