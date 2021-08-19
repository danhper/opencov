defmodule Opencov.Services.GithubAuth do
  alias ExPublicKey.RSAPrivateKey

  def now, do: Timex.now() |> Timex.to_unix()

  def signer() do
    signer = Joken.Signer.parse_config(:rs256)

    token_config =
      %{}
      |> Joken.Config.add_claim("iss", fn -> now - 60 end)
      |> Joken.Config.add_claim("exp", fn -> now + 60 end)
      |> Joken.Config.add_claim("iat", fn -> "133119" end)

    {:ok, jwt, _} = Joken.generate_and_sign(token_config, %{}, signer)
    jwt
  end
end
