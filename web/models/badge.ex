defmodule Opencov.Badge do
  use Opencov.Web, :model

  schema "badges" do
    field :project_id, :integer
    field :image, :binary
    field :format, :string
    field :coverage, :float

    timestamps
  end

  def get_or_create(project, format \\ Application.get_env(:opencov, :badge_format)) do
    if badge = find(project.id, format) do
      if project.current_coverage == badge.coverage, do: {:ok, badge},
      else: update(project, badge, format)
    else
      create(project, format)
    end
  end

  defp find(project_id, format) do
    format = to_string(format)
    Opencov.Repo.one(
      from b in Opencov.Badge,
      select: b,
      where: b.project_id == ^project_id and b.format == ^format
    )
  end

  defp make(project, format, cb) do
    if is_binary(format), do: format = String.to_atom(format)
    case Opencov.BadgeCreator.make_badge(project.current_coverage, format: format) do
      {:ok, ^format, image} -> {:ok, cb.(image)}
      {:error, e} -> {:error, e}
    end
  end

  defp create(project, format) do
    make project, format, fn image ->
      Opencov.Repo.insert! %Opencov.Badge{
        coverage: project.current_coverage,
        project_id: project.id,
        image: image,
        format: to_string(format)
      }
    end
  end

  defp update(project, badge, format) do
    make project, format, fn image ->
      Opencov.Repo.update!(%{badge | coverage: project.current_coverage, image: image})
    end
  end
end
