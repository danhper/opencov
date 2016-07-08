defmodule Opencov.Repo do
  use Ecto.Repo, otp_app: :opencov
  use Scrivener, page_size: 10

  require Ecto.Query
  alias Ecto.Query

  def latest(model, opts \\ []) do
    all(Query.from m in model,
      select: m,
      limit: ^Keyword.get(opts, :limit, 5),
      order_by: [desc: field(m, ^Keyword.get(opts, :order, :inserted_at))]
    )
  end


  def first(queryable, opts \\ [])
  def first(nil, _opts), do: nil
  def first(queryable, opts) do
    queryable |> Ecto.Query.first |> one(opts)
  end

  def first!(queryable, opts \\ [])
  def first!(nil, _opts), do: nil
  def first!(queryable, opts) do
    queryable |> Ecto.Query.first |> one!(opts)
  end
end
