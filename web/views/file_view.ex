defmodule Opencov.FileView do
  use Opencov.Web, :view

  import Opencov.CommonView
  import Scrivener.HTML

  @max_length 15

  def filters do
    %{
      "changed" => "Changed",
      "cov_changed" => "Coverage changed",
      "covered" => "Covered",
      "unperfect" => "Unperfect"
    }
  end

  def short_name(name) do
    if String.length(name) < 20 do
      name
    else
      name
        |> String.split("/")
        |> Enum.reverse
        |> Enum.reduce({[], 0}, fn s, {n, len} ->
          if len <= @max_length, do: {[s|n], len + String.length(s)}, else: {[String.first(s)|n], len + 1}
        end)
        |> elem(0)
        |> Enum.join("/")
    end
  end
end
