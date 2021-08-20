defmodule Librecov.Badge do
  use Librecov.Web, :model

  import Ecto.Query

  schema "badges" do
    field(:image, :binary)
    field(:format, :string)
    field(:coverage, :float)

    belongs_to(:project, Librecov.Project)

    timestamps()
  end

  def for_project(query, %Librecov.Project{id: project_id}),
    do: for_project(query, project_id)

  def for_project(query, project_id) when is_integer(project_id),
    do: query |> where(project_id: ^project_id)

  def with_format(query, format) when is_atom(format),
    do: with_format(query, Atom.to_string(format))

  def with_format(query, format),
    do: query |> where(format: ^format)

  def default_format(),
    do: Application.get_env(:librecov, :badge_format)
end
