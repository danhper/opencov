defmodule Librecov.FileManagerTest do
  use Librecov.ModelCase

  alias Librecov.File
  alias Librecov.FileManager

  @coverage_lines [0, nil, 3, nil, 0, 1]

  test "changeset with valid attributes" do
    changeset = FileManager.changeset(%File{}, Map.put(params_for(:file), :job_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FileManager.changeset(%File{}, %{})
    refute changeset.valid?
  end

  test "empty coverage" do
    file = insert(:file, coverage_lines: [])
    assert file.coverage == 0
  end

  test "normal coverage" do
    file = insert(:file, coverage_lines: @coverage_lines)
    assert file.coverage == 50
  end

  test "set_previous_file when a previous file exists" do
    project = insert(:project)

    previous_job =
      insert(:job, job_number: 1, build: insert(:build, project: project, build_number: 1))

    job = insert(:job, job_number: 1, build: insert(:build, project: project, build_number: 2))
    assert job.previous_job_id == previous_job.id

    previous_file = insert(:file, job: previous_job, name: "file")
    file = insert(:file, job: job, name: "file")
    assert file.previous_file_id == previous_file.id
    assert file.previous_coverage == previous_file.coverage
  end
end
