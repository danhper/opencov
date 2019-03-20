defmodule Opencov.Middleware.EndpointLogging do

  def init(options) do
    options
  end

  def call(conn, _opts) do
    start = System.monotonic_time()
    request_id = Plug.Conn.get_resp_header(conn, "x-request-id")
    Plug.Conn.register_before_send(conn, fn conn ->
      stop = System.monotonic_time()
      diff = System.convert_time_unit(stop - start, :native, :millisecond)
      IO.puts Poison.encode!(%{
          "request_id" => "#{request_id}",
          "severity" => "INFO",
          "tags" => ["inbound", "endpoint"],
          "duration" => "#{diff}",
          "method" => "#{conn.method}",
          "path" => "#{conn.request_path}",
          "status" => "#{conn.status}",
          "message" => "#{
                        if conn.status >= 400 do
                          if is_binary(conn.resp_body) do
                            title = Regex.run(~r/<title>\s*(.+?)\s*<\/title>/, conn.resp_body)
                            if title != nil do
                              Enum.at(title,1)
                            else
                              :fail
                            end
                          else
                            :fail
                          end
                        else
                          :ok
                        end
                      }"
        })
      conn
    end)
  end

end
