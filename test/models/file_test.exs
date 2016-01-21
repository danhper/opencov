defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

  @coverage_lines [0, nil, 3, nil, 0, 1]

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, Map.put(fields_for(:file), :job_id, 1))
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
    previous_job = create(:job, job_number: 1, build: create(:build, project: project, build_number: 1))
    job = create(:job, job_number: 1, build: create(:build, project: project, build_number: 2))
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

  test "covered and unperfect filters" do
    create(:file, coverage_lines: [0, 0])
    create(:file, coverage_lines: [100, 100])
    normal = create(:file, coverage_lines: [50, 100, 0])
    normal_only = File.base_query |> File.with_filters(["unperfect", "covered"]) |> Opencov.Repo.all
    assert Enum.count(normal_only) == 1
    assert List.first(normal_only).id == normal.id
  end

  test "changed and cov_changed filters" do
    previous_file = create(:file, source: "print 'hello'", coverage_lines: [0, 100])
    file = create(:file, coverage_lines: [0, 100], job: previous_file.job)
    cov_changed = File.base_query |> File.with_filters(["cov_changed"]) |> Opencov.Repo.all
    changed = File.base_query |> File.with_filters(["changed"]) |> Opencov.Repo.all
    refute file.id in Enum.map(cov_changed, &(&1.id))
    assert file.id in Enum.map(changed, &(&1.id))
  end
end
