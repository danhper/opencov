defmodule Opencov.FileView do
  use Opencov.Web, :view

  import Opencov.CommonView
  import Scrivener.HTML

  @max_length 20

  def filters do
    %{
      "changed" => "Changed",
      "cov_changed" => "Coverage changed",
      "covered" => "Covered",
      "unperfect" => "Unperfect"
    }
  end

  def short_name(name) do
    if String.length(name) < @max_length do
      name
    else
      name
        |> String.split("/")
        |> Enum.reverse
        |> Enum.reduce({[], 0}, fn s, {n, len} ->
          if len + String.length(s) <= @max_length do
            {[s|n], len + String.length(s)}
          else
            {[String.first(s)|n], len + 1}
          end
        end)
        |> elem(0)
        |> Enum.join("/")
    end
  end
end
