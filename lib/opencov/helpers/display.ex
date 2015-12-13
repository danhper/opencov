defmodule Opencov.Helpers.Display do
  def display(value) when is_boolean(value), do: bool(value)
  def display(value) when is_atom(value), do: atom(value)
  def display(value) when is_binary(value), do: text(value)

  def bool(true), do: "✔"
  def bool(_), do: "×"

  def atom(a) when is_atom(a) do
    a |> Atom.to_string |> String.split("_") |> Enum.join(" ") |> String.capitalize
  end

  def text(text) do
    {:safe, text |> String.split("\n") |> Enum.join("<br>")}
  end
end
