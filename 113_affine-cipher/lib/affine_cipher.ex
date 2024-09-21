defmodule AffineCipher do
  import Integer, only: [mod: 2]

  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: _b} = key, message) do
    m = mmi(a, 1)
    if m, do: {:ok, do_encode(key, message)}, else: {:error, "a and m must be coprime."}
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: _b} = key, encrypted) do
    m = mmi(a, 1)
    if m, do: {:ok, do_decode(key, encrypted, m)}, else: {:error, "a and m must be coprime."}
  end

  defp do_encode(%{a: a, b: b}, message) do
    message
    |> String.downcase()
    |> String.replace(~r/[\s,.]/, "")
    |> to_charlist()
    |> Enum.map(&encode_char(&1, a, b))
    |> Enum.chunk_every(5)
    |> Enum.map_join(" ", &to_string/1)
  end

  defp do_decode(%{a: _a, b: b}, encrypted, m) do
    encrypted
    |> String.replace(~r/[\s]/, "")
    |> to_charlist()
    |> Enum.map(&decode_char(&1, b, m))
    |> to_string()
  end

  defp encode_char(char, a, b) when char in ?a..?z, do: ?a + mod(a * (char - ?a) + b, 26)
  defp encode_char(char, _a, _b), do: char

  defp decode_char(char, b, m) when char in ?a..?z, do: ?a + mod(m * (char - ?a - b), 26)
  defp decode_char(char, _b, _m), do: char

  defp mmi(n, _x) when rem(n, 2) == 0 or rem(n, 13) == 0, do: nil
  defp mmi(n, x) when rem(n * x, 26) == 1, do: x
  defp mmi(n, x), do: mmi(n, x + 1)
end
