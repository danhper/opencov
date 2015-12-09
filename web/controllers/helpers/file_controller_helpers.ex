defmodule Opencov.Helpers.FileControllerHelpers do
  alias Opencov.File

  # FIXME: we should make file distinct by name instead but this is not yet
  # supported by scrivener
  def files_with_filter([job|_], params), do: files_with_filter(job, params)

  def files_with_filter(job, params) do
    filters = Map.get(params, "filters", [])
    order_field = Map.get(params, "order_field", "diff")
    order_direction = Map.get(params, "order_direction", :desc)
    query = File.for_job(job) |> File.with_filters(filters) |> File.sort_by(order_field, order_direction)
    paginator = query |> Opencov.Repo.paginate(params)
    [
      filters: filters,
      paginator: paginator,
      files: paginator.entries,
      order: {order_field, order_direction}
    ]
  end
end
