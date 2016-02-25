defmodule Opencov.Admin.SettingsController do
  use Opencov.Web, :controller

  alias Opencov.SettingsManager
  alias Opencov.Repo

  # plug :scrub_params, "settings" when action in [:update]

  def edit(conn, _params) do
    settings = SettingsManager.get!
    changeset = SettingsManager.changeset(settings)
    render(conn, "edit.html", settings: settings, changeset: changeset)
  end

  def update(conn, %{"settings" => settings_params}) do
    settings = SettingsManager.get!
    changeset = SettingsManager.changeset(settings, settings_params)

    case Repo.update(changeset) do
      {:ok, _settings} ->
        conn
        |> put_flash(:info, "Settings updated successfully.")
        |> redirect(to: admin_dashboard_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", settings: settings, changeset: changeset)
    end
  end
end
