defmodule Opencov.Types.JSON do
  @behaviour Ecto.Type

  def type, do: :json

  def cast(any), do: {:ok, any}
  def load(value), do: Jason.decode(value)
  def dump(value) when is_binary(value), do: {:ok, value}
  def dump(value), do: Jason.encode(value)
end
