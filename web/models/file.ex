defmodule Opencov.File do
  use Opencov.Web, :model

  schema "files" do
    field :name, :string
    field :source, :string
    field :coverage, :float
    field :coverage_lines, Opencov.Types.JSON

    belongs_to :job, Opencov.Job

    timestamps
  end

  before_insert :generate_coverage

  @required_fields ~w(name source coverage_lines job_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defp generate_coverage(changeset) do
    lines = get_change(changeset, :coverage_lines)
    if lines do
      put_change(changeset, :coverage, compute_coverage(lines))
    end
  end

  defp compute_coverage(lines) do
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
