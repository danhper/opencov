# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineObject70 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :auto_trigger_checks
  ]

  @type t :: %__MODULE__{
          :auto_trigger_checks =>
            [GitHubV3RESTAPI.Model.ReposOwnerRepoCheckSuitesPreferencesAutoTriggerChecks.t()]
            | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineObject70 do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :auto_trigger_checks,
      :list,
      GitHubV3RESTAPI.Model.ReposOwnerRepoCheckSuitesPreferencesAutoTriggerChecks,
      options
    )
  end
end
