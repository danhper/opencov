defmodule Opencov.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Opencov.Web, :controller
      use Opencov.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Timex.Ecto.Timestamps
      use Opencov.Core

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def manager do
    quote do
      alias Opencov.Repo
      use Opencov.Core

      import Ecto.Changeset
    end
  end

  def service do
    quote do
      alias Opencov.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Opencov.Repo
      import Ecto.Query, only: [from: 1, from: 2]

      import Opencov.Router.Helpers
      import Opencov.Helpers.Authentication
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Opencov.Router.Helpers
      import Opencov.ErrorHelpers
      import Opencov.FormHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Opencov.Repo
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def mailer do
    quote do
      use Opencov.Mailer
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
