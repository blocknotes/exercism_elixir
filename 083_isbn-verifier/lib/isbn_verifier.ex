defmodule IsbnVerifier do
  @isbn_regex ~r/\A(\d{9})(\d|X)\z/

  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn = String.replace(isbn, "-", "")

    case Regex.run(@isbn_regex, isbn) do
      [_, digits, checksum] -> valid_isbn?(digits, checksum)
      _ -> false
    end
  end

  defp valid_isbn?(digits, checksum) do
    digits
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Stream.with_index()
    |> Enum.reduce(0, fn {d, i}, acc -> acc + d * (10 - i) end)
    |> match_checksum?(checksum)
  end

  defp match_checksum?(value, "X"), do: rem(value + 10, 11) == 0
  defp match_checksum?(value, checksum), do: rem(value + String.to_integer(checksum), 11) == 0
end
