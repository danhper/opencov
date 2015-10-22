defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

  @valid_attrs %{coverage: "120.5", job_id: 42, name: "some content", old_coverage: "120.5", source: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
