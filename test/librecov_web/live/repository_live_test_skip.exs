defmodule Librecov.RepositoryLiveTest do
  use Librecov.ConnCase

  import Phoenix.LiveViewTest

  alias Librecov.Data

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:repository) do
    {:ok, repository} = Data.create_repository(@create_attrs)
    repository
  end

  defp create_repository(_) do
    repository = fixture(:repository)
    %{repository: repository}
  end

  describe "Index" do
    setup [:create_repository]

    test "lists all repositories", %{conn: conn, repository: repository} do
      {:ok, _index_live, html} = live(conn, Routes.repository_index_path(conn, :index))

      assert html =~ "Listing Repositories"
    end

    test "saves new repository", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.repository_index_path(conn, :index))

      assert index_live |> element("a", "New Repository") |> render_click() =~
               "New Repository"

      assert_patch(index_live, Routes.repository_index_path(conn, :new))

      assert index_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repository-form", repository: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repository_index_path(conn, :index))

      assert html =~ "Repository created successfully"
    end

    test "updates repository in listing", %{conn: conn, repository: repository} do
      {:ok, index_live, _html} = live(conn, Routes.repository_index_path(conn, :index))

      assert index_live |> element("#repository-#{repository.id} a", "Edit") |> render_click() =~
               "Edit Repository"

      assert_patch(index_live, Routes.repository_index_path(conn, :edit, repository))

      assert index_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repository-form", repository: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repository_index_path(conn, :index))

      assert html =~ "Repository updated successfully"
    end

    test "deletes repository in listing", %{conn: conn, repository: repository} do
      {:ok, index_live, _html} = live(conn, Routes.repository_index_path(conn, :index))

      assert index_live |> element("#repository-#{repository.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#repository-#{repository.id}")
    end
  end

  describe "Show" do
    setup [:create_repository]

    test "displays repository", %{conn: conn, repository: repository} do
      {:ok, _show_live, html} = live(conn, Routes.repository_show_path(conn, :show, repository))

      assert html =~ "Show Repository"
    end

    test "updates repository within modal", %{conn: conn, repository: repository} do
      {:ok, show_live, _html} = live(conn, Routes.repository_show_path(conn, :show, repository))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Repository"

      assert_patch(show_live, Routes.repository_show_path(conn, :edit, repository))

      assert show_live
             |> form("#repository-form", repository: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#repository-form", repository: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repository_show_path(conn, :show, repository))

      assert html =~ "Repository updated successfully"
    end
  end
end
