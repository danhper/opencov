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

    def from_params_and_body(params, body) do
      source_files = SourceGenerator.digest!(body)

      job_definition = JobGenerator.digest!(params)

      %Job{job_definition | source_files: source_files}
    end

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
        def resolve(%SourceFile{} = original, %SourceFile{} = override, _resolver) do
          if original.name == override.name do
            %SourceFile{
              original
              | coverage: merge_coverage_list(original.coverage, override.coverage),
                branches: merge_branches(original.branches, override.branches)
            }
          else
            Logger.warn(
              "Not merging #{original.name} with #{override.name} because it is not the same file. Will return unmodified"
            )

            original
          end
        end

        defp merge_coverage_list(nil, coverage2), do: coverage2
        defp merge_coverage_list(coverage1, nil), do: coverage1

        defp merge_coverage_list(coverage1, coverage2) do
          List.zip([coverage1, coverage2])
          |> Enum.map(fn {a, b} -> merge_coverage(a, b) end)
        end

        # [line, block, branch, taken]
        defp merge_branches(branch1, branch2) do
          List.zip([branch1, branch2])
          |> Enum.map(fn {a, b} -> merge_branch(a, b) end)
        end

        defp merge_branch([l, bl, br, ta], [_, _, _, ta2]) do
          [l, bl, br, ta + ta2]
        end

        defp merge_coverage(nil, nil), do: nil
        defp merge_coverage(nil, n), do: n
        defp merge_coverage(n, nil), do: n
        defp merge_coverage(n, n2), do: n + n2
      end
    end
  end
end
