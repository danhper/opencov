defmodule Librecov.RepositoryLive.Index do
  use Librecov.Web, :live_view

  alias Librecov.Data
  alias Librecov.Services.Projects
  alias Librecov.Services.Authorizations

  @impl true
  def mount(_params, session, socket) do
    {:ok, user, _} = Authentication.resource_from_session(session)
    repositories = list_repositories(user)

    {:ok,
     socket
     |> assign(repositories: repositories, user: user, projects: list_projects(repositories))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Repository")
    |> assign(:repository, Data.get_repository!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Repository")
    |> assign(:repository, %{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Repositories")
    |> assign(:repository, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    repository = Data.get_repository!(id)
    {:ok, _} = Data.delete_repository(repository)

    {:noreply, assign(socket, :repositories, list_repositories(socket.assigns.user))}
  end

  defp list_repositories(user) do
    {:ok, auth} = user.authorizations |> List.first() |> Authorizations.ensure_fresh()
    Data.list_repositories(auth)
  end

  defp list_projects(repos) do
    repos
    |> Enum.map(&"github_#{&1.id}")
    |> Projects.projects_for_repos()
    |> Projects.all()
    |> Projects.with_latest_build()
  end
end
