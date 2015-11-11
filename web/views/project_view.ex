defmodule Opencov.ProjectView do
  use Opencov.Web, :view

  import Opencov.CommonView

  def repository_class(project) do
    url = project.base_url
    cond do
      String.contains?(url, "github.com") -> "fa-github"
      String.contains?(url, "bitbucket.com") -> "fa-bitbucket"
      true -> "fa-database"
    end
  end
end
