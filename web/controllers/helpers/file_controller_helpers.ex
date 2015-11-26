defmodule Opencov.Helpers.FileControllerHelpers do
  alias Opencov.File

  def files_with_filter(job, params) do
    filters = Dict.get(params, "filters", [])
    query = File.for_job(job) |> File.with_filters(filters) |> File.order_by_coverage
    paginator = query |> Opencov.Repo.paginate(params)
    [filters: filters, paginator: paginator, files: paginator.entries]
  end
end
