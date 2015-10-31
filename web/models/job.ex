defmodule Opencov.Job do
  use Opencov.Web, :model

  alias Ecto.Model

  alias Opencov.File

  schema "jobs" do
    field :coverage, :float, default: 0.0
    field :previous_job_id, :integer
    field :run_at, Ecto.DateTime
    field :files_count, :integer
    field :job_number, :integer
    field :previous_coverage, :float

    belongs_to :build, Opencov.Build
    has_one :previous_job, Opencov.Job
    has_many :files, Opencov.File

    timestamps
  end

  @required_fields ~w(build_id)
  @optional_fields ~w(run_at job_number)

  before_insert :check_job_number
  before_insert :set_previous_values

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_from_json!(build, params) do
    {source_files, params} = Dict.pop(params, "source_files", [])
    job = Model.build(build, :jobs) |> changeset(params) |> Opencov.Repo.insert!
    Enum.each source_files, fn file_params ->
      Model.build(job, :files) |> File.changeset(file_params) |> Opencov.Repo.insert!
    end
    job |> Opencov.Repo.preload(:files) |> update_coverage
  end

  defp check_job_number(changeset) do
    if get_change(changeset, :job_number) do
      changeset
    else
      set_job_number(changeset)
    end
  end

  defp set_job_number(changeset) do
    build_id = get_change(changeset, :build_id)
    job = Opencov.Repo.one(
      from j in Opencov.Job,
      select: j,
      where: j.build_id == ^build_id,
      order_by: [desc: j.job_number],
      limit: 1
    )
    job_number = if job, do: job.job_number + 1, else: 1
    put_change(changeset, :job_number, job_number)
  end

  defp set_previous_values(changeset) do
    {build_id, job_number} = {get_change(changeset, :build_id), get_change(changeset, :job_number)}
    previous_build_id = Opencov.Repo.get!(Opencov.Build, build_id).previous_build_id
    previous_job = search_previous_job(previous_build_id, job_number)
    if previous_job do
      change(changeset, %{previous_job_id: previous_job.id, previous_coverage: previous_job.coverage})
    else
      changeset
    end
  end

  defp search_previous_job(nil, _), do: nil
  defp search_previous_job(previous_build_id, job_number) do
    Opencov.Repo.one(
      from j in Opencov.Job,
      select: j,
      where: j.build_id == ^previous_build_id and j.job_number == ^job_number
    )
  end

  def update_coverage(job) do
    Opencov.Repo.update! %{job | coverage: compute_coverage(job)}
  end

  def compute_coverage(job) do
    lines = Enum.flat_map job.files, &(&1.coverage_lines)
    Opencov.File.compute_coverage(lines)
  end
end
