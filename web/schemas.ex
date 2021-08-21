defmodule Librecov.Web.Schemas do
  alias OpenApiSpex.Schema
  alias Librecov.Web.ApiSpec

  defmodule Job do
    require OpenApiSpex

    OpenApiSpex.schema(ApiSpec.spec().components.schemas["Job"])

    defmodule SourceFile do
      require OpenApiSpex

      OpenApiSpex.schema(ApiSpec.spec().components.schemas["Job"].properties.source_files.items)
    end
  end
end
