defmodule Librecov.Mailer do
  @templates_base_path Path.join(__DIR__, "../../web/templates/mailers")

  defmacro __using__(_opts) do
    quote do
      require EEx
      import Librecov.Mailer
    end
  end

  defmacro define_template(action, params, format) do
    quote bind_quoted: [action: action, params: params, format: format] do
      path = Librecov.Mailer.template_path(__MODULE__, action, format)
      EEx.function_from_file(:defp, String.to_atom("#{action}_#{format}"), path, params)
    end
  end

  defmacro define_html_template(action, params) do
    quote bind_quoted: [action: action, params: params] do
      define_template(action, params, "html")
    end
  end

  defmacro define_text_template(action, params) do
    quote bind_quoted: [action: action, params: params] do
      define_template(action, params, "text")
    end
  end

  defmacro define_templates(action, params) do
    quote bind_quoted: [action: action, params: params] do
      define_text_template(action, params)
      define_html_template(action, params)
    end
  end

  def template_path(module, action, format) do
    Path.join([@templates_base_path, module_path(module), "#{action}.#{format}.eex"])
  end

  defp module_path(module) do
    module
    |> Atom.to_string()
    |> String.replace(~r/^Elixir\.Librecov\./, "")
    |> String.replace(".", "/")
    |> Macro.underscore()
    |> String.replace(~r/_mailer$/, "")
  end
end
