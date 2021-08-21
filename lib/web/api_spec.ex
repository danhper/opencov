defmodule Librecov.Web.ApiSpec do
  alias OpenApiSpex.OpenApi

  @behaviour OpenApi
  @oaspec "openapi.json"
          |> File.read!()
          |> Jason.decode!()
          |> OpenApiSpex.OpenApi.Decode.decode()

  @impl OpenApi
  def spec, do: @oaspec
end
