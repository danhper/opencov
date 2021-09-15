defmodule Opencov.Helpers.Authentication do
  def demo?() do
    !!Application.get_env(:opencov, :demo)[:enabled]
  end

  def current_user(conn) do
    Map.fetch!(conn.assigns, :current_user)
  end

  def user_signed_in?(conn) do
    Map.fetch(conn.assigns, :current_user) != :error
  end
end
