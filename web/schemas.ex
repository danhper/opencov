defmodule Librecov.Web.Schemas do
  alias OpenApiSpex.Cast
  alias Librecov.Web.ApiSpec

  defmodule CodecovV2 do
    defmodule Parameters do
      require OpenApiSpex

      OpenApiSpex.schema(
        ApiSpec.spec().paths["/upload/v2"].post.parameters
        |> Librecov.Helpers.Schemas.schema_from_parameters()
      )

      def cast_and_validate(params) do
        Cast.cast(@schema, params, %{})
      end

      def cast_and_validate!(params) do
        case cast_and_validate(params) do
          {:ok, result} -> result
          {:error, e} -> raise e
        end
      end
    end
  end

  defmodule Job do
    require OpenApiSpex

    OpenApiSpex.schema(ApiSpec.spec().components.schemas["Job"])

    def cast_and_validate(params) do
      Cast.cast(@schema, params, %{})
    end

    def cast_and_validate!(params) do
      case cast_and_validate(params) do
        {:ok, result} -> result
        {:error, e} -> raise e
      end
    end

    defmodule SourceFile do
      require Logger
      require OpenApiSpex

      OpenApiSpex.schema(ApiSpec.spec().components.schemas["Job"].properties.source_files.items)

      def cast_and_validate(params) do
        Cast.cast(@schema, params, %{})
      end

      def cast_and_validate!(params) do
        case cast_and_validate(params) do
          {:ok, result} -> result
          {:error, e} -> raise e
        end
      end

      defimpl DeepMerge.Resolver, for: SourceFile do
        def resolve(original = %SourceFile{}, override = %SourceFile{}, _resolver) do
          if original.name == override.name do
            %SourceFile{
              original
              | coverage: merge_coverage(original.coverage, override.coverage),
                branches: merge_branches(original.branches, override.branches)
            }
          else
            Logger.warn(
              "Not merging #{original.name} with #{override.name} because it is not the same file. Will return unmodified"
            )

            original
          end
        end

        defp merge_coverage(coverage1, coverage2) do
          List.zip([coverage1, coverage2])
          |> Enum.map(fn {a, b} -> a + b end)
        end

        # [line, block, branch, taken]
        defp merge_branches(branch1, branch2) do
          List.zip([branch1, branch2])
          |> Enum.map(fn {a, b} -> merge_branch(a, b) end)
        end

        defp merge_branch([l, bl, br, ta], [_, _, _, ta2]) do
          [l, bl, br, ta + ta2]
        end
      end
    end
  end
end
