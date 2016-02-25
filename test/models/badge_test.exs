defmodule Opencov.BadgeTest do
  use Opencov.ModelCase

  alias Opencov.Badge

  setup do
    svg_badge = create(:badge, format: "svg")
    png_badge = create(:badge, format: "png")
    {:ok, svg_badge: svg_badge, png_badge: png_badge}
  end

  test "default_format/0" do
    assert Badge.default_format == "svg"
  end

  test "for_project/2", %{svg_badge: svg_badge, png_badge: png_badge} do
    badge = Badge |> Badge.for_project(svg_badge.project) |> Repo.one!
    assert badge.id == svg_badge.id

    badge = Badge |> Badge.for_project(png_badge.project.id) |> Repo.one!
    assert badge.id == png_badge.id
  end

  test "with_format/2", %{svg_badge: svg_badge, png_badge: png_badge} do
    badge = Badge |> Badge.with_format("svg") |> Repo.one!
    assert badge.id == svg_badge.id

    badge = Badge |> Badge.with_format(:png) |> Repo.one!
    assert badge.id == png_badge.id
  end
end
