defmodule Api.V1.JobView do
  use Opencov.Web, :view

  @attributes ~w(id project_id build_id coverage)a

  def render("show.json", %{job: job}) do
    job |> Map.take(@attributes)
  end
end
