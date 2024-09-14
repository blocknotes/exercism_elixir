defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> normalize()
    |> do_encode()
  end

  defp normalize(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
  end

  defp do_encode(""), do: ""

  defp do_encode(str) do
    c = columns(str)
    r = rows(str, c)

    String.pad_trailing(str, c * r)
    |> String.graphemes()
    |> Enum.chunk_every(c)
    |> List.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join()))
    |> Enum.join(" ")
  end

  defp columns(str) do
    str
    |> String.length()
    |> :math.sqrt()
    |> ceil()
  end

  defp rows(str, c) do
    str
    |> String.length()
    |> Kernel./(c)
    |> ceil()
  end
end
