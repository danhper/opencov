defmodule Librecov.RepositoryLive.Show do
  use Librecov.Web, :live_view

  import Librecov.CommonView
  alias Librecov.Data
  alias Librecov.Services.Projects

  @impl true
  def mount(_params, session, socket) do
    {:ok, user, _} = Authentication.resource_from_session(session)
    {:ok, assign(socket, user: user)}
  end

  @impl true
  def handle_params(%{"repo" => repo, "owner" => owner}, _, socket) do
    repository = get_repository(socket.assigns.user, repo, owner)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:repository, repository)
     |> assign(
       :project,
       Projects.get_project_by(repo_id: "github_#{repository.id}") |> Projects.with_latest_build() ||
         %Librecov.Project{builds: []}
     )}
  end

  defp get_repository(user, repo, owner) do
    Data.get_repository!(user.authorizations |> List.first(), owner, repo)
  end

  defp page_title(:show), do: "Show Repository"
  defp page_title(:edit), do: "Edit Repository"
end
