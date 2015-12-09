defmodule Opencov.Repo do
  use Ecto.Repo, otp_app: :opencov
  use Scrivener, page_size: 10

  require Ecto.Query

  def latest(model, opts \\ []) do
    all(Ecto.Query.from m in model,
      select: m,
      limit: ^Keyword.get(opts, :limit, 5),
      order_by: [desc: field(m, ^Keyword.get(opts, :order, :inserted_at))]
    )
  end
end
