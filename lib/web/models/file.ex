defmodule Librecov.File do
  use Librecov.Web, :model

  import Ecto.Query

  defimpl Jason.Encoder, for: Librecov.File do
    def encode(model, opts) do
      model
      |> Map.take([:name, :source])
      |> Map.put(:coverage, model.coverage_lines)
      |> Jason.Encoder.encode(opts)
    end
  end

  alias Librecov.Job

  schema "files" do
    field(:name, :string)
    field(:source, :string)
    field(:coverage, :float)
    field(:previous_coverage, :float)
    field(:coverage_lines, {:array, :integer})

    belongs_to(:job, Job)
    belongs_to(:previous_file, Librecov.File)

    timestamps()
  end

  @allowed_sort_fields ~w(name coverage diff)

  def sort_by(query, param, order) when order in ~w(asc desc),
    do: sort_by(query, param, String.to_atom(order))

  def sort_by(query, param, order) when param in @allowed_sort_fields,
    do: sort_by(query, String.to_atom(param), order)

  def sort_by(query, :diff, order) do
    query |> order_by([f], [{^order, fragment("abs(? - ?)", f.previous_coverage, f.coverage)}])
  end

  def sort_by(query, param, order) do
    order =
      if __schema__(:type, param) == :string,
        do: order,
        else: reverse_order(order)

    query |> order_by([f], [{^order, field(f, ^param)}])
  end

  # defp reverse_order(:asc), do: :desc
  # defp reverse_order(:desc), do: :asc

  def for_job(query \\ Librecov.File, job)

  def for_job(query, jobs) when is_list(jobs), do: query |> where([f], f.job_id in ^jobs)
  def for_job(query, %Librecov.Job{id: job_id}), do: for_job(query, job_id)
  def for_job(query, job_id), do: query |> where([f], f.job_id == ^job_id)

  def with_filters(query, [filter | rest]), do: with_filters(with_filter(query, filter), rest)
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

  def with_name(query, name) do
    query |> where(name: ^name)
  end

  def order_by_coverage(query, order \\ :desc) do
    query |> order_by([f], [{^order, f.coverage}])
  end

  def compute_coverage(lines) do
    relevant_count = relevant_lines_count(lines)

    if relevant_count == 0,
      do: 0.0,
      else: covered_lines_count(lines) * 100 / relevant_count
  end

  def relevant_lines_count(lines),
    do: lines |> Enum.reject(fn n -> is_nil(n) end) |> Enum.count()

  def covered_lines_count(lines),
    do: lines |> Enum.reject(fn n -> is_nil(n) or n == 0 end) |> Enum.count()
end
