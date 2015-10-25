defmodule Opencov.Job do
  use Opencov.Web, :model

  alias Opencov.File

  schema "jobs" do
    field :coverage, :float
    field :run_at, Ecto.DateTime
    field :files_count, :integer
    field :number, :integer
    field :previous_coverage, :float

    belongs_to :build, Opencov.Build
    has_many :files, Opencov.File

    timestamps
  end

  @required_fields ~w(build_id coverage number)
  @optional_fields ~w()

  before_insert :check_job_number

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_from_json!(params) do
    {source_files, params} = Dict.pop(params, :source_files, [])
    job = Opencov.Repo.insert! changeset(params)
    Enum.each source_files, fn file_params ->
      Dict.put(file_params, :job_id, job.id) |> File.changeset |> Opencov.Repo.insert!
    end
    update_coverage(job |> Opencov.Repo.preload(:files))
  end

  defp check_job_number(changeset) do
    if get_change(changeset, :number) do
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
      order_by: [desc: j.number],
      limit: 1
    )
    job_number = if job, do: job.number + 1, else: 1
    put_change(changeset, :number, job_number)
  end

  def update_coverage(job) do
    Opencov.Repo.update! %{job | coverage: compute_coverage(job)}
  end

  def compute_coverage(job) do
    lines = Enum.flat_map job.files, &(&1.coverage_lines)
    Opencov.File.compute_coverage(lines)
  end
end
