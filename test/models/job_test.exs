defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job
  alias Ecto.Changeset
  alias Ecto.Model

  @valid_attrs %{build_id: 42, coverage: 42, number: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "set_job_number" do
    previous_job = Opencov.Repo.insert! Job.changeset(%Job{}, @valid_attrs)
    job = Opencov.Repo.insert! Changeset.change(Job.changeset(%Job{}, @valid_attrs), number: nil)
    assert job.number == previous_job.number + 1
  end

  test "compute_coverage" do
    job = Opencov.Repo.insert! Job.changeset(%Job{}, @valid_attrs)
    coverage_lines = [0, 1, nil, 0, 2, 1]
    Opencov.Repo.insert! Model.build(job, :files, name: "a", source: "", coverage_lines: coverage_lines)
    other_coverage_lines = [0, 0, nil, 0]
    Opencov.Repo.insert! Model.build(job, :files, name: "b", source: "", coverage_lines: other_coverage_lines)
    coverage = job |> Opencov.Repo.preload(:files) |> Job.compute_coverage
    assert coverage == 37.5  # (3 / 8 * 100)
  end
end
