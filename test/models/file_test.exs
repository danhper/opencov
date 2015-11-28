defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

  @coverage_lines [0, nil, 3, nil, 0, 1]

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, Dict.put(fields_for(:file), :job_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, %{})
    refute changeset.valid?
  end

  test "empty coverage" do
    file = create(:file, coverage_lines: [])
    assert file.coverage == 0
  end

  test "normal coverage" do
    file = create(:file, coverage_lines: @coverage_lines)
    assert file.coverage == 50
  end

  test "set_previous_file when a previous file exists" do
    project = create(:project)
    previous_job = create(:job, job_number: 1, build: create(:build, project: project))
    job = create(:job, job_number: 1, build: create(:build, project: project))
    assert job.previous_job_id == previous_job.id

    previous_file = create(:file, job: previous_job, name: "file")
    file = create(:file, job: job, name: "file")
    assert file.previous_file_id == previous_file.id
    assert file.previous_coverage == previous_file.coverage
  end

  test "for_job" do
    build = create(:build)
    job = create(:job, build: build)
    other_job = create(:job, build: build)
    file = create(:file, job: job)
    other_file = create(:file, job: other_job)

    files_ids = Opencov.Repo.all(File.for_job(job)) |> Enum.map(fn f -> f.id end)
    other_files_ids = Opencov.Repo.all(File.for_job(other_job)) |> Enum.map(fn f -> f.id end)

    assert files_ids == [file.id]
    assert other_files_ids == [other_file.id]
  end
end
