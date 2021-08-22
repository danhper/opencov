defmodule Librecov.Repo do
  use Ecto.Repo, otp_app: :librecov, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10

  require Ecto.Query
  alias Ecto.Query
  alias EventBus.Model.Event

  def latest(model, opts \\ []) do
    all(
      Query.from(m in model,
        select: m,
        limit: ^Keyword.get(opts, :limit, 5),
        order_by: [desc: field(m, ^Keyword.get(opts, :order, :inserted_at))]
      )
    )
  end

  def first(queryable, opts \\ [])
  def first(nil, _opts), do: nil

  def first(queryable, opts) do
    queryable |> Ecto.Query.first() |> one(opts)
  end

  def first!(queryable, opts \\ [])
  def first!(nil, _opts), do: nil

  def first!(queryable, opts) do
    queryable |> Ecto.Query.first() |> one!(opts)
  end

  def update_and_notify(changeset, opts \\ []) do
    with {:ok, struct} <- update(changeset, opts) do
      %Event{
        id: "#{struct.__meta__.source}_#{struct.id}_#{UUID.uuid1()}",
        data: {struct, changeset.changes},
        topic: :updated
      }
      |> EventBus.notify()

      {:ok, struct}
    end
  end

  def update_and_notify!(changeset, opts \\ []) do
    case update_and_notify(changeset, opts) do
      {:error, changeset} ->
        raise %Ecto.InvalidChangesetError{action: :update, changeset: changeset}

      {:ok, struct} ->
        struct
    end
  end

  def insert_and_notify(struct_or_changeset, opts \\ []) do
    with {:ok, struct} <- insert(struct_or_changeset, opts) do
      %Event{id: "#{struct.__meta__.source}_#{struct.id}", data: struct, topic: :inserted}
      |> EventBus.notify()

      {:ok, struct}
    end
  end

  def insert_and_notify!(struct_or_changeset, opts \\ []) do
    case insert_and_notify(struct_or_changeset, opts) do
      {:error, changeset} ->
        raise %Ecto.InvalidChangesetError{action: :insert, changeset: changeset}

      {:ok, struct} ->
        struct
    end
  end
end
