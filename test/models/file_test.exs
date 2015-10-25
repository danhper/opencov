defmodule Opencov.FileTest do
  use Opencov.ModelCase

  alias Opencov.File

  @coverage_lines [0, nil, 3, nil, 0, 1]

  @valid_attrs %{name: "some content", source: "some content", coverage_lines: @coverage_lines, job_id: 30}
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
end
