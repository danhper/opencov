defmodule Opencov.PaginationHelpers do
  import PhoenixHTMLHelpers.Tag
  import PhoenixHTMLHelpers.Link

  def pagination_links(conn, page, opts), do: pagination_links(conn, page, [], opts)

  def pagination_links(conn, page, args, opts) do
    path = Keyword.fetch!(opts, :path)
    action = Keyword.get(opts, :action, :index)
    params = Keyword.drop(opts, [:path, :action])
    current = page.page_number
    pages = Enum.to_list(max(1, current - 5)..min(page.total_pages, current + 5))
    pages = Enum.uniq([1 | pages] ++ [page.total_pages])

    links =
      if(current > 1, do: [{current - 1, "<<"}], else: []) ++
        Enum.map(pages, &{&1, to_string(&1)}) ++
        if current < page.total_pages, do: [{current + 1, ">>"}], else: []

    content_tag(
      :nav,
      content_tag(
        :ul,
        Enum.map(links, fn {number, label} ->
          url = apply(path, [conn, action] ++ args ++ [Keyword.put(params, :page, number)])

          content_tag(:li, link(label, to: url),
            class: if(number == current, do: "active", else: "")
          )
        end),
        class: "pagination"
      )
    )
  end
end
