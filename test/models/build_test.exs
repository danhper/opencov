defmodule Opencov.BuildTest do
  use Opencov.ModelCase

  alias Opencov.Build

  test "current_for_project when no build exist" do
    create(:build, completed: false)
    refute Build.current_for_project(Build, create(:project)) |> Repo.first
  end

  test "current_for_project when build exists" do
    existing_build = create(:build, completed: false)
    build = Build.current_for_project(Build, existing_build.project) |> Repo.first
    assert build.id == existing_build.id
  end
end
