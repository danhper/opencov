defmodule Librecov.Plug.MultipartJob do
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

    handle(content_type, conn)
  end

  def handle("multipart/form-data", %{params: %{"json_file" => file}} = conn) do
    conn
    |> put_parsed_job(file |> read_file())
  end

  def handle(_, %{params: %{"json" => json}} = conn) when is_binary(json) do
    conn
    |> put_parsed_job(json)
  end

  def handle(content_type, conn) do
    conn
  end

  def put_parsed_job(conn, json) do
    parsed_json = Jason.decode!(json)

    %{
      (conn
       |> Conn.put_req_header("content-type", "application/json"))
      | params: parsed_json,
        body_params: parsed_json
    }
  end

  defp read_file(%Plug.Upload{content_type: "gzip/json", path: path}) do
    path
    |> File.stream!([], 2048)
    |> StreamGzip.gunzip()
    |> Enum.into("")
  end

  defp read_file(%Plug.Upload{path: path}) do
    path
    |> File.read!()
  end
end
