defmodule Opencov.Job do
  use Opencov.Web, :model

  import Ecto.Query

  schema "jobs" do
    field :coverage, :float, default: 0.0
    field :previous_job_id, :integer
    field :run_at, Timex.Ecto.DateTime
    field :files_count, :integer
    field :job_number, :integer
    field :previous_coverage, :float

    belongs_to :build, Opencov.Build
    has_one :previous_job, Opencov.Job
    has_many :files, Opencov.File

    timestamps
  end

  def compute_coverage(job) do
    lines = Enum.flat_map job.files, &(&1.coverage_lines)
    Opencov.File.compute_coverage(lines)
  end

  def for_build(query, %Opencov.Build{id: id}), do: for_build(query, id)
  def for_build(query, build_id) when is_integer(build_id),
    do: query |> where(build_id: ^build_id)
end
