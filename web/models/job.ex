defmodule Opencov.Job do
  use Opencov.Web, :model

  schema "jobs" do
    field :coverage, :float
    field :run_at, Ecto.DateTime
    field :files_count, :integer
    field :number, :integer
    field :previous_coverage, :float

    belongs_to :build, Opencov.Build
    has_many :files, Opencov.File

    timestamps
  end

  @required_fields ~w(build_id coverage number)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  # defp compute_number(model) do
  #   Opencov.Repo.one(
  #     from b in Opencov.Job,
  #     select: b,
  #     where: b.build_id == ^number,
  #     order_by: [desc: b.number],
  #     limit: 1
  #   )
  # end
  #
  def compute_coverage(model) do
    lines = Enum.flat_map model.files, &(&1.coverage_lines)
    Opencov.File.compute_coverage(lines)
  end
end
