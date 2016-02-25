defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

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
    normal_only = File |> File.with_filters(["unperfect", "covered"]) |> Opencov.Repo.all
    assert Enum.count(normal_only) == 1
    assert List.first(normal_only).id == normal.id
  end

  test "changed and cov_changed filters" do
    previous_file = create(:file, source: "print 'hello'", coverage_lines: [0, 100])
    file = create(:file, coverage_lines: [0, 100], job: previous_file.job)
    cov_changed = File |> File.with_filters(["cov_changed"]) |> Opencov.Repo.all
    changed = File |> File.with_filters(["changed"]) |> Opencov.Repo.all
    refute file.id in Enum.map(cov_changed, &(&1.id))
    assert file.id in Enum.map(changed, &(&1.id))
  end
end
