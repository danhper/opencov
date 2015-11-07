defmodule Opencov.File do
  use Opencov.Web, :model

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
    field :coverage_lines, Opencov.Types.JSON

    belongs_to :job, Job

    timestamps
  end

  before_insert :generate_coverage

  @required_fields ~w(name source coverage_lines job_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(normalize_params(params), @required_fields, @optional_fields)
  end

  def for_job(job) do
    Opencov.Repo.all(
      from f in Opencov.File,
      select: f,
      where: f.job_id == ^job.id,
      order_by: [desc: f.coverage]
    )
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
