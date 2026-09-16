defmodule Opencov.PaginationHelpersTest do
  use ExUnit.Case, async: true
  import Opencov.PaginationHelpers

  test "nested pagination retains the action, resource and filters" do
    page = %Scrivener.Page{page_number: 2, total_pages: 3}

    html =
      pagination_links(Plug.Test.conn(:get, "/"), page, [42],
        path: &Opencov.Router.Helpers.job_path/4,
        action: :show,
        filters: ["covered"],
        order_field: "name",
        order_direction: "asc"
      )
      |> Phoenix.HTML.safe_to_string()

    assert html =~ "/jobs/42?"
    assert html =~ "filters[]=covered"
    assert html =~ "order_field=name"
    assert html =~ "page=1"
    assert html =~ "page=3"
    assert html =~ "class=\"active\""
  end
end
