defmodule Librecov.Helpers.Authentication do
  def current_user(conn) do
    Map.fetch!(conn.assigns, :current_user)
  end

  def user_signed_in?(conn) do
    Map.fetch(conn.assigns, :current_user) != :error
  end
end
