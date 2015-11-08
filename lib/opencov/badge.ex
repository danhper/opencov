defmodule Opencov.Badge do
  require EEx

  # values here are taken from https://github.com/badges/shields
  @base_width 89
  @extra_width 7
  @template_path Path.join(__DIR__, "templates/badge_template.eex")

  EEx.function_from_file :defp, :template, @template_path, [:coverage, :width, :extra_width, :bg_color]

  def make_badge(coverage, options \\ []) do
    digits_num = coverage |> Integer.to_string |> String.length
    extra_width = (digits_num - 1) * @extra_width
    width = @base_width + extra_width
    color = badge_color(coverage)
    template(coverage, width, extra_width, color) |> get_image(options)
  end

  defp get_image(svg, options) do
    case options[:format] do
      :svg  -> {:ok, :svg, svg}
      format ->
        if is_nil(format), do: format = :png
        transform(svg, format)
    end
  end

  def transform(svg, format) do
    dir = Temp.mkdir!("opencov")
    {svg_path, output_path} = {Path.join(dir, "coverage.svg"), Path.join(dir, "coverage.#{format}")}
    File.write!(svg_path, svg)
    case make_output(svg_path, output_path) do
      {:ok, output} ->
        File.rm_rf!(dir)
        {:ok, format, output}
      e -> e
    end
  end

  defp make_output(svg_path, output_path) do
    try do
      System.cmd("convert", [svg_path, output_path])
      File.read(output_path)
    rescue
      ErlangError -> {:error, "failed to run convert"}
    end
  end

  defp badge_color(coverage) do
    color = cond do
      coverage == 0  -> "red"
      coverage < 80  -> "yellow"
      coverage < 90  -> "yellowgreen"
      coverage < 100 -> "green"
      true           -> "brightgreen"
    end
    hex_color(color)
  end

  defp hex_color("red"), do: "#e05d44"
  defp hex_color("yellow"), do: "#dfb317"
  defp hex_color("yellowgreen"), do: "#a4a61d"
  defp hex_color("green"), do: "#97CA00"
  defp hex_color("brightgreen"), do: "#4c1"
end
