defmodule Opencov.FileManagerTest do
  use Opencov.ModelCase

  alias Opencov.File
  alias Opencov.FileManager

  @coverage_lines [0, nil, 3, nil, 0, 1]

  test "changeset with valid attributes" do
    changeset = FileManager.changeset(%File{}, Map.put(params_for(:file), :job_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FileManager.changeset(%File{}, %{})
    refute changeset.valid?
  end

  test "changeset accepts an empty source (#13)" do
    params = %{"name" => "pkg/__init__.py", "source" => "", "coverage" => [nil], "job_id" => 1}
    assert FileManager.changeset(%File{}, params).valid?
  end

  test "changeset accepts source_digest instead of source (#10)" do
    params = %{"name" => "lib/example.rb", "source_digest" => "1eb14b3a053f951ca925f2fd4d633eeb",
               "coverage" => [nil, 1, 1, 0], "job_id" => 1}
    changeset = FileManager.changeset(%File{}, params)
    assert changeset.valid?
    assert Ecto.Changeset.get_field(changeset, :source_digest) == "1eb14b3a053f951ca925f2fd4d633eeb"
  end

  test "changeset computes source_digest from source" do
    params = %{"name" => "a.rb", "source" => "return 0", "coverage" => [1], "job_id" => 1}
    changeset = FileManager.changeset(%File{}, params)
    assert Ecto.Changeset.get_field(changeset, :source_digest) ==
      Base.encode16(:crypto.hash(:md5, "return 0"), case: :lower)
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
    previous_job = insert(:job, job_number: 1, build: insert(:build, project: project, build_number: 1))
    job = insert(:job, job_number: 1, build: insert(:build, project: project, build_number: 2))
    assert job.previous_job_id == previous_job.id

    previous_file = insert(:file, job: previous_job, name: "file")
    file = insert(:file, job: job, name: "file")
    assert file.previous_file_id == previous_file.id
    assert file.previous_coverage == previous_file.coverage
  end
end
