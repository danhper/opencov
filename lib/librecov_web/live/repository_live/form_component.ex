defmodule Librecov.RepositoryLive.FormComponent do
  use Librecov.Web, :live_component

  alias Librecov.Data

  @impl true
  def update(%{repository: repository} = assigns, socket) do
    changeset = Data.change_repository(repository)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"repository" => repository_params}, socket) do
    changeset =
      socket.assigns.repository
      |> Data.change_repository(repository_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"repository" => repository_params}, socket) do
    save_repository(socket, socket.assigns.action, repository_params)
  end

  defp save_repository(socket, :edit, repository_params) do
    case Data.update_repository(socket.assigns.repository, repository_params) do
      {:ok, _repository} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repository updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_repository(socket, :new, repository_params) do
    case Data.create_repository(repository_params) do
      {:ok, _repository} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repository created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
