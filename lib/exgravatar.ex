defmodule Exgravatar do
  @moduledoc """
  An Elixir module for generating [Gravatar](http://gravatar.com) urls.
  """

  @domain "gravatar.com"

  @doc """
  Generates a gravatar url for the given email address.

  ## Examples

      iex> Exgravatar.gravatar_url("jdoe@example.com", secure: false)
      "http://gravatar.com/avatar/694ea0904ceaf766c6738166ed89bafb"

      iex> Exgravatar.gravatar_url("jdoe@example.com", s: 256)
      "https://secure.gravatar.com/avatar/694ea0904ceaf766c6738166ed89bafb?s=256"

      iex> Exgravatar.gravatar_url("jdoe@example.com")
      "https://secure.gravatar.com/avatar/694ea0904ceaf766c6738166ed89bafb"
  """
  def gravatar_url(email, opts \\ []) do
    {secure, opts} = Keyword.pop(opts, :secure, true)

    %URI{}
    |> host(secure)
    |> hash_email(email)
    |> parse_options(opts)
    |> to_string
  end

  defp parse_options(uri, []), do: %URI{uri | query: nil}
  defp parse_options(uri, opts), do: %URI{uri | query: URI.encode_query(opts)}

  defp host(uri, true), do: %URI{uri | scheme: "https", host: "secure.#{@domain}"}
  defp host(uri, false), do: %URI{uri | scheme: "http", host: @domain}

  defp hash_email(uri, email) do
    hash = :crypto.hash(:md5, String.downcase(email)) |> Base.encode16(case: :lower)
    %URI{uri | path: "/avatar/#{hash}"}
  end
end
