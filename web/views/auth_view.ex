defmodule Opencov.AuthView do
  use Opencov.Web, :view

  def initial_value(form, param) do
    compute_value(param, Map.get(form.params, to_string(param), ""), demo?())
  end

  defp compute_value(_param, value, false), do: value
  defp compute_value(param, "", true), do: Application.get_env(:opencov, :demo)[param]
  defp compute_value(_param, value, _), do: value

  def demo?() do
    !!Application.get_env(:opencov, :demo)[:enabled]
  end
end
