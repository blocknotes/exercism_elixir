defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode(str, rails), do: rail_fence_indexes(str, rails) |> Enum.map_join(&String.at(str, &1))

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str

  def decode(str, rails) do
    str
    |> rail_fence_indexes(rails)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {i, j}, acc ->
      char = String.at(str, j)
      Map.put_new(acc, i, char)
    end)
    |> Enum.sort()
    |> Enum.map_join(fn {_i, c} -> c end)
  end

  defp rail_fence_indexes(str, rails) do
    len = String.length(str)
    last_rail = rails - 1

    for r <- 0..last_rail,
        i <- 0..len,
        index = calc_index(r, i, last_rail),
        index < len,
        do: index
  end

  defp calc_index(r, i, last_rail) when r in [0, last_rail], do: r + last_rail * 2 * i
  defp calc_index(r, i, last_rail), do: r * (1 - 2 * rem(i, 2)) + last_rail * 2 * div(i + 1, 2)
end
