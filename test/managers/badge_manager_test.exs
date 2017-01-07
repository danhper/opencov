defmodule Opencov.BadgeManagerTest do
  use Opencov.ModelCase

  alias Opencov.BadgeManager

  @format :svg

  setup do
    project = insert(:project, current_coverage: 58.4)
    {:ok, project: project}
  end

  test "get_or_create when no badge exist", %{project: project} do
    {:ok, badge} = BadgeManager.get_or_create(project, @format)
    assert badge.id
    assert badge.coverage == project.current_coverage
  end

  test "get_or_create when badge exists", %{project: project} do
    {:ok, badge} = BadgeManager.get_or_create(project, @format)
    assert badge.id

    {:ok, new_badge} = BadgeManager.get_or_create(project, @format)
    assert badge.id == new_badge.id
  end

  test "get_or_create when badge exists and coverage changed", %{project: project} do
    {:ok, badge} = BadgeManager.get_or_create(project, @format)
    assert badge.id

    new_coverage = 62.4
    project = Repo.update!(Ecto.Changeset.change(project, current_coverage: new_coverage))

    {:ok, new_badge} = BadgeManager.get_or_create(project, @format)
    assert badge.id == new_badge.id
    assert new_badge.coverage == new_coverage
  end
end
