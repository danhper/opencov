defmodule Opencov.Helpers.FileControllerHelpers do
  alias Opencov.File

  def files_with_filter(job, params) do
    filters = Dict.get(params, "filters", [])
    order_field = Dict.get(params, "order_field", "diff")
    order_direction = Dict.get(params, "order_direction", :desc)
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
