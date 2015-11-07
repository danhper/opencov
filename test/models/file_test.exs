defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

  @coverage_lines [0, nil, 3, nil, 0, 1]

  @build_attrs %{build_number: 42, project_id: 42}
  @job_attrs %{coverage: 42, job_number: 42}

  @valid_attrs %{name: "some name", source: "some content", coverage_lines: @coverage_lines, job_id: 30}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "empty coverage" do
    file = Repo.insert! Ecto.Changeset.put_change(File.changeset(%File{}, @valid_attrs), :coverage_lines, [])
    assert file.coverage == 0
  end

  test "normal coverage" do
    file = Repo.insert! File.changeset(%File{}, @valid_attrs)
    assert file.coverage == 50
  end

  test "for_job" do
    build = Opencov.Repo.insert! Opencov.Build.changeset(%Opencov.Build{project_id: 1}, @build_attrs)
    job = Opencov.Repo.insert! Opencov.Job.changeset(%Opencov.Job{build_id: build.id}, Dict.put(@job_attrs, :job_number, 1))
    other_job = Opencov.Repo.insert! Opencov.Job.changeset(%Opencov.Job{build_id: build.id}, Dict.put(@job_attrs, :job_number, 2))
    file = Repo.insert! File.changeset(%File{job_id: job.id}, Dict.put(@valid_attrs, :job_id, job.id))
    other_file = Repo.insert! File.changeset(%File{}, Dict.put(@valid_attrs, :job_id, other_job.id))

    files_ids = File.for_job(job) |> Enum.map(fn f -> f.id end)
    other_files_ids = File.for_job(other_job) |> Enum.map(fn f -> f.id end)

    assert files_ids == [file.id]
    assert other_files_ids == [other_file.id]
  end
end
