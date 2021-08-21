defmodule Librecov.JobManager do
  use Librecov.Web, :manager

  import Ecto.Query
  import Librecov.Job
  alias Librecov.Job
  alias Librecov.FileManager

  @required_fields ~w(build_id)a
  @optional_fields ~w(run_at job_number files_count)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> prepare_changes(&check_job_number/1)
    |> prepare_changes(&set_previous_values/1)
  end

  defp check_job_number(changeset) do
    if get_change(changeset, :job_number) do
      changeset
    else
      set_job_number(changeset)
    end
  end

  defp set_job_number(changeset) do
    build_id = get_change(changeset, :build_id) || changeset.data.build_id
    job = Job |> for_build(build_id) |> order_by(desc: :job_number) |> Repo.first()
    job_number = if job, do: job.job_number + 1, else: 1
    put_change(changeset, :job_number, job_number)
  end

  defp set_previous_values(changeset) do
    build_id = get_change(changeset, :build_id) || changeset.data.build_id
    job_number = get_change(changeset, :job_number)
    previous_build_id = Librecov.Repo.get!(Librecov.Build, build_id).previous_build_id
    previous_job = search_previous_job(previous_build_id, job_number)

    if previous_job do
      change(changeset, %{
        previous_job_id: previous_job.id,
        previous_coverage: previous_job.coverage
      })
    else
      changeset
    end
  end

  defp search_previous_job(nil, _), do: nil

  defp search_previous_job(previous_build_id, job_number),
    do: Job |> for_build(previous_build_id) |> where(job_number: ^job_number) |> Repo.first()

  def update_coverage(job) do
    job = change(job, coverage: compute_coverage(job)) |> Repo.update!() |> Repo.preload(:build)
    Librecov.BuildManager.update_coverage(job.build)
    job
  end

  def create_from_json!(build, params) do
    {source_files, params} = Map.pop(params, "source_files", [])
    params = Map.put(params, "files_count", Enum.count(source_files))
    job = Ecto.build_assoc(build, :jobs) |> changeset(params) |> Repo.insert!()

    Enum.each(source_files, fn file_params ->
      Ecto.build_assoc(job, :files) |> FileManager.changeset(file_params) |> Repo.insert!()
    end)

    job |> Repo.preload(:files) |> update_coverage
  end

  def preload_files(job_or_jobs) do
    job_or_jobs |> Repo.preload(:files)
  end
end
