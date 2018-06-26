# RouterWithMonitor add a prometheus metrics monitoring to Router plug
defmodule Opencov.Middleware.RouterWithMonitor do
  use Prometheus.PlugInstrumenter

  plug Opencov.Router

  def label_value(:action, {conn, _}) do
    if Map.has_key?(conn.private, :phoenix_controller) do
      "#{Phoenix.Controller.controller_module(conn)}:#{Phoenix.Controller.action_name(conn)}"
    else
      "nil_#{conn.status}"
    end
  end

  def label_value(:status, {conn, _}) do
    if conn.status >= 500 do
      "fail"
    else
      "ok"
    end
  end
end
