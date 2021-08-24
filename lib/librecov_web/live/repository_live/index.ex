defmodule Librecov.RepositoryLive.Index do
  use Librecov.Web, :live_view

  alias Librecov.Data

  @impl true
  def mount(_params, session, socket) do
    {:ok, user, _} = Authentication.resource_from_session(session)
    {:ok, socket |> assign(repositories: list_repositories(user), user: user)}
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
    Data.list_repositories(user.authorizations |> List.first())
  end
end
