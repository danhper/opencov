defmodule Opencov.Mailer do
  @templates_base_path Path.join(__DIR__, "../../web/templates/mailers")

  defmacro __using__(_opts) do
    quote do
      require EEx
      import Opencov.Mailer
    end
  end

  defmacro define_templates(action, params) do
    quote do
      define_text_template(unquote(action), unquote(params))
      define_html_template(unquote(action), unquote(params))
    end
  end

  defmacro define_text_template(action, params) do
    quote do
      path = Opencov.Mailer.template_path(__MODULE__, unquote(action), "text")
      EEx.function_from_file :defp, String.to_atom("#{unquote(action)}_text"), path, unquote(params)
    end
  end

  defmacro define_html_template(action, params) do
    quote do
      path = Opencov.Mailer.template_path(__MODULE__, unquote(action), "html")
      EEx.function_from_file :defp, String.to_atom("#{unquote(action)}_html"), path, unquote(params)
    end
  end

  def template_path(module, action, format) do
    Path.join([@templates_base_path, module_path(module), "#{action}.#{format}.eex"])
  end

  defp module_path(module) do
    module
    |> Atom.to_string
    |> String.replace(~r/^Elixir\.Opencov\./, "")
    |> String.replace(".", "/")
    |> Mix.Utils.underscore
    |> String.replace(~r/_mailer$/, "")
  end
end
