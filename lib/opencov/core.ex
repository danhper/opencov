defmodule Opencov.Core do
  defmacro __using__(_opts) do
    quote do
      import Opencov.Core, only: [pipe_when: 3]
    end
  end

  defmacro pipe_when(left, condition, fun) do
    quote do
      if Opencov.Core.should_pipe(left, unquote(condition)) do
        unquote(left) |> unquote(fun)
      else
        unquote(left)
      end
    end
  end

  defmacro should_pipe(left, condition) when is_function(condition) do
    quote do
      unquote(left) |> unquote(condition)
    end
  end

  defmacro should_pipe(_, condition), do: condition
end
