defmodule Opencov.Job do
  use Opencov.Web, :model

  import Ecto.Query

  schema "jobs" do
    field :coverage, :float, default: 0.0
    field :run_at, :utc_datetime_usec
    field :files_count, :integer
    field :job_number, :integer
    field :previous_coverage, :float

    belongs_to :build, Opencov.Build
    belongs_to :previous_job, Opencov.Job
    has_many :files, Opencov.File

    timestamps()
  end

  def compute_coverage(job) do
    lines = Enum.flat_map job.files, &(&1.coverage_lines)
    Opencov.File.compute_coverage(lines)
  end

  def for_build(query, %Opencov.Build{id: id}), do: for_build(query, id)
  def for_build(query, build_id) when is_integer(build_id),
    do: query |> where(build_id: ^build_id)
end
