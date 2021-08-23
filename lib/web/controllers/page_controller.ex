defmodule Librecov.PageController do
  use Librecov.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
