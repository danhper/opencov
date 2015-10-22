defmodule Opencov.Build do
  use Opencov.Web, :model

  schema "builds" do
    field :number, :integer
    field :previous_build_id, :integer
    field :coverage, :float
    field :completed, :boolean
    field :previous_coverage, :float
    field :build_started_at, Ecto.DateTime

    belongs_to :project, Opencov.Project
    has_many :jobs, Opencov.Job
    has_one :previous_build, Opencov.Build, foreign_key: :previous_build_id

    timestamps
  end

  @required_fields ~w(number project_id coverage)
  @optional_fields ~w()

  before_insert :set_build_started_at
  before_insert :set_previous_values

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defp set_build_started_at(changeset) do
    if get_change(changeset, :build_started_at) do
      changeset
    else
      put_change(changeset, :build_started_at, Ecto.DateTime.utc)
    end
  end

  defp set_previous_values(changeset) do
    previous_build = get_change(changeset, :previous_build)
    unless previous_build do
      previous_build = search_build_before(get_change(changeset, :number))
      if previous_build, do: changeset = put_change(changeset, :previous_build_id, previous_build.id)
    end
    if !previous_build or get_change(changeset, :previous_coverage) do
      changeset
    else
      put_change(changeset, :previous_coverage, previous_build.coverage)
    end
  end

  defp search_build_before(number) do
    Opencov.Repo.one(
      from b in Opencov.Build,
      select: b,
      where: b.number < ^number,
      order_by: [desc: b.number],
      limit: 1
    )
  end
end
