defmodule Opencov.Api.V1.ProjectView do
  use Opencov.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, Opencov.Api.V1.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{name: project.name}
  end
end
