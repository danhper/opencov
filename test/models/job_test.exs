defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job

  @valid_attrs %{author_email: "some content", author_name: "some content", branch: "some content", build_id: 42, commit_message: "some content", commit_sha: "some content", coverage: 42, files_count: 42, number: 42, old_coverage: 42, run_at: "2010-04-17 14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
