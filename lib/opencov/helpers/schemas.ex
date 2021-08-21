defmodule Librecov.Helpers.Schemas do
  alias OpenApiSpex.{Parameter, Schema}

  def schema_from_parameters(parameters) do
    parameters
    |> Enum.reduce(%Schema{type: :object}, fn para, schema ->
      schema |> populate_properties(para) |> populate_required(para)
    end)
  end

  def populate_properties(%Schema{properties: prev_properties} = schema, %Parameter{
        name: name,
        schema: parameter_schema
      }) do
    %Schema{
      schema
      | properties: (prev_properties || %{}) |> Map.put(name, parameter_schema)
    }
  end

  def populate_required(%Schema{required: prev_required} = schema, %Parameter{
        name: name,
        required: required
      }) do
    cond do
      required ->
        %Schema{
          schema
          | required: [name | prev_required || []]
        }

      true ->
        schema
    end
  end
end
