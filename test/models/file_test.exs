defmodule Librecov.FileTest do
  use Librecov.ModelCase

  alias Librecov.File

  test "for_job" do
    build = insert(:build)
    job = insert(:job, build: build)
    other_job = insert(:job, build: build)
    file = insert(:file, job: job)
    other_file = insert(:file, job: other_job)

    files_ids = Librecov.Repo.all(File.for_job(job)) |> Enum.map(fn f -> f.id end)
    other_files_ids = Librecov.Repo.all(File.for_job(other_job)) |> Enum.map(fn f -> f.id end)

    assert files_ids == [file.id]
    assert other_files_ids == [other_file.id]
  end

  test "covered and unperfect filters" do
    insert(:file, coverage_lines: [0, 0])
    insert(:file, coverage_lines: [100, 100])
    normal = insert(:file, coverage_lines: [50, 100, 0])
    normal_only = File |> File.with_filters(["unperfect", "covered"]) |> Librecov.Repo.all()
    assert Enum.count(normal_only) == 1
    assert List.first(normal_only).id == normal.id
  end

  test "changed and cov_changed filters" do
    previous_file =
      insert(:file, source: "print 'hello'", coverage_lines: [0, 100]) |> Repo.preload(:job)

    file = insert(:file, coverage_lines: [0, 100], job: previous_file.job)
    cov_changed = File |> File.with_filters(["cov_changed"]) |> Librecov.Repo.all()
    changed = File |> File.with_filters(["changed"]) |> Librecov.Repo.all()
    refute file.id in Enum.map(cov_changed, & &1.id)
    assert file.id in Enum.map(changed, & &1.id)
  end
end
