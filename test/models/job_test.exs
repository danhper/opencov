defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job

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
end
