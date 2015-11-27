defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job
  alias Ecto.Changeset
  alias Ecto.Model

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov", run_at: "2015-11-27T15:33:46+09:00"}
  @build_attrs %{coverage: 50.5, build_number: 42}

  @valid_attrs %{coverage: 42, job_number: 42}
  @invalid_attrs %{}

  setup do
    project = Opencov.Repo.insert! Opencov.Project.changeset(%Opencov.Project{}, @project_attrs)
    build = Opencov.Repo.insert! Opencov.Build.changeset(Model.build(project, :builds), @build_attrs)
    valid_attrs = Dict.put(@valid_attrs, :build_id, build.id)
    build_attrs = Dict.put(@build_attrs, :project_id, project.id)
    {:ok, valid_attrs: valid_attrs, build_attrs: build_attrs, build: build}
  end

  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = Job.changeset(%Job{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "set_job_number", %{valid_attrs: valid_attrs} do
    previous_job = Opencov.Repo.insert! Job.changeset(%Job{}, valid_attrs)
    job = Opencov.Repo.insert! Changeset.change(Job.changeset(%Job{}, valid_attrs), job_number: nil)
    assert job.job_number == previous_job.job_number + 1
  end

  test "compute_coverage", %{valid_attrs: valid_attrs} do
    job = Opencov.Repo.insert! Job.changeset(%Job{}, valid_attrs)
    Opencov.Repo.insert! Model.build(job, :files, name: "a", source: "", coverage_lines: [0, 1, nil, 0, 2, 1])
    Opencov.Repo.insert! Model.build(job, :files, name: "b", source: "", coverage_lines: [0, 0, nil, 0])
    coverage = job |> Opencov.Repo.preload(:files) |> Job.compute_coverage
    assert coverage == 37.5  # (3 / 8 * 100)
  end

  test "set_previous_values when no previous job exists", %{valid_attrs: valid_attrs} do
    job = Opencov.Repo.insert! Job.changeset(%Job{}, valid_attrs)
    assert job.previous_job_id == nil
  end

  test "set_previous_values when a previous job exists", %{valid_attrs: valid_attrs, build_attrs: build_attrs} do
    previous_job = Opencov.Repo.insert! Job.changeset(%Job{}, valid_attrs)
    build_attrs = Dict.put(build_attrs, :build_number, Dict.get(build_attrs, :build_number) + 1)
    build = Opencov.Repo.insert! Opencov.Build.changeset(%Opencov.Build{}, build_attrs)
    job = Opencov.Repo.insert! Job.changeset(%Job{}, Dict.put(valid_attrs, :build_id, build.id))
    assert job.previous_job_id == previous_job.id
    assert job.previous_coverage == previous_job.coverage
  end

  test "create_from_json!", %{build: build} do
    dummy_coverage = Opencov.Fixtures.dummy_coverage
    job = Opencov.Job.create_from_json!(build, dummy_coverage)
    assert job.id != nil
    assert Enum.count(job.files) == Enum.count(dummy_coverage["source_files"])
    assert job.files_count == Enum.count(dummy_coverage["source_files"])
    assert job.coverage > 90
  end
end
