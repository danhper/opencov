defmodule Librecov.FormHelpers do
  import Librecov.ErrorHelpers
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form

  @input_default_opts [label: [], type: :text_input, attrs: [], args: []]

  def form_group(form, field, do: block) do
    content_tag(:div, block, class: "form-group #{state_class(form, field)}")
  end

  def input(form, field, opts \\ []) do
    opts = Keyword.merge(@input_default_opts, opts)

    form_group form, field do
      [
        make_label_tag(form, field, opts),
        make_input_tag(form, field, opts),
        error_tag(form, field)
      ]
      |> Enum.reject(&is_nil/1)
    end
  end

  defp make_label_tag(form, field, opts) do
    scope = to_string(opts[:scope] || form.name)
    text = Gettext.dgettext(Librecov.Gettext, scope, to_string(field))
    label(form, field, text, add_class(opts[:label], "form-label"))
  end

  defp make_input_tag(form, field, opts) do
    {mod, fun} =
      case opts[:type] do
        {_mod, _fun} = type -> type
        fun -> {Phoenix.HTML.Form, fun}
      end

    args = [form, field] ++ opts[:args] ++ [add_class(opts[:attrs], "form-control")]
    apply(mod, fun, args)
  end

  defp add_class(opts, class) do
    base_class = Keyword.get(opts, :class, "")
    Keyword.put(opts, :class, base_class <> " " <> class)
  end
end
