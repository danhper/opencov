defmodule Opencov.BuildTest do
  use Opencov.ModelCase

  alias Opencov.Build

  test "current_for_project when no build exist" do
    insert(:build, completed: false)
    refute Build.current_for_project(Build, insert(:project)) |> Repo.first()
  end

  test "current_for_project when build exists" do
    existing_build = insert(:build, completed: false) |> Repo.preload(:project)
    build = Build.current_for_project(Build, existing_build.project) |> Repo.first()
    assert build.id == existing_build.id
  end
end
