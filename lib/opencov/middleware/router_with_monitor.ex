# RouterWithMonitor add a prometheus metrics monitoring to Router plug
defmodule Opencov.Middleware.RouterWithMonitor do
  use Prometheus.PlugInstrumenter

  plug Opencov.Router

  def label_value(:action, {conn, _}) do
    "#{Phoenix.Controller.controller_module(conn)}:#{Phoenix.Controller.action_name(conn)}"
  end

  def label_value(:status, {conn, _}) do
    if conn.status >= 500 do
      "fail"
    else
      "ok"
    end
  end
end
