defmodule Librecov.WebhookView do
  use Librecov.Web, :view

  @attributes ~w(id project_id build_number coverage completed)a

  def render("show.json", %{build: build}) do
    build |> Map.take(@attributes)
  end
end
