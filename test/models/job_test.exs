defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, Dict.put(fields_for(:job), :build_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, %{})
    refute changeset.valid?
  end

  test "set_job_number" do
    previous_job = create(:job)
    job = create(:job, job_number: nil, build: previous_job.build)
    assert job.job_number == previous_job.job_number + 1
  end

  test "compute_coverage" do
    job = create(:job)
    create(:file, job: job, coverage_lines: [0, 1, nil, 0, 2, 1])
    create(:file, job: job, coverage_lines: [0, 0, nil, 0])
    coverage = job |> Opencov.Repo.preload(:files) |> Job.compute_coverage
    assert coverage == 37.5  # (3 / 8 * 100)
  end

  test "set_previous_values when no previous job exists" do
    job = create(:job)
    assert job.previous_job_id == nil
  end

  test "set_previous_values when a previous job exists" do
    project = create(:project)
    previous_job = create(:job, job_number: 1, build: create(:build, project: project))
    job = create(:job, job_number: 1, build: create(:build, project: project))
    assert job.previous_job_id == previous_job.id
    assert job.previous_coverage == previous_job.coverage
  end

  test "create_from_json!" do
    dummy_coverage = Opencov.Fixtures.dummy_coverage
    job = Opencov.Job.create_from_json!(create(:build), dummy_coverage)
    assert job.id != nil
    assert Enum.count(job.files) == Enum.count(dummy_coverage["source_files"])
    assert job.files_count == Enum.count(dummy_coverage["source_files"])
    assert job.coverage > 90
  end
end
