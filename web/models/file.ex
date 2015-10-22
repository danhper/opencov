defmodule Opencov.File do
  use Opencov.Web, :model

  schema "files" do
    field :name, :string
    field :source, :string
    field :coverage, :float
    field :coverage_lines, :string
    field :old_coverage, :float

    belongs_to :job, Opencov.Job

    timestamps
  end

  @required_fields ~w(job_id name source coverage_lines)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
