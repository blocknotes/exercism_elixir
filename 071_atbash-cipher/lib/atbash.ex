defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.replace(~r/[^a-zA-Z0-9]/, "")
    |> String.downcase()
    |> to_charlist()
    |> Enum.map(&translate/1)
    |> Enum.chunk_every(5)
    |> Enum.map_join(" ", &to_string/1)
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.replace(" ", "")
    |> to_charlist()
    |> Enum.map(&translate/1)
    |> to_string()
  end

  defp translate(c) when c in ?a..?z, do: ?a + ?z - c
  defp translate(c), do: c
end
