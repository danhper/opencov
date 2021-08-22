defmodule Librecov.Plug.PlainText do
  require Logger

  @moduledoc """
  Module plug that will cast a given multiform upload and convert it to the expected json
  """

  @behaviour Plug

  alias Plug.Conn

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  def call(conn, _) do
    content_type =
      case Conn.get_req_header(conn, "content-type") do
        [header_value | _] ->
          header_value
          |> String.split(";")
          |> Enum.at(0)

        _ ->
          nil
      end

    Logger.debug("Request with content type: #{content_type}")

    handle(content_type, conn)
  end

  def handle("text/plain", conn) do
    {:ok, data, _conn_details} = Plug.Conn.read_body(conn)
    Logger.debug("Attaching parsed body to conn[:body_params]")
    %{conn | body_params: data}
  end

  def handle(_content_type, conn) do
    conn
  end
end
