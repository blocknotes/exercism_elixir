defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    lines = String.split(input, "\n") |> Enum.reverse()
    max_length = Enum.map(lines, &String.length/1) |> Enum.max()
    {lines, _} = pad_lines(lines)
    chars = Enum.reverse(lines) |> Enum.map(&String.graphemes/1)

    Enum.map(0..(max_length - 1), fn i ->
      Enum.map(chars, &Enum.at(&1, i))
    end)
    |> Enum.map_join("\n", &Enum.join/1)
  end

  defp pad_lines(lines) do
    Enum.map_reduce(lines, 0, fn line, acc ->
      acc = Enum.max([acc, String.length(line)])
      {String.pad_trailing(line, acc), acc}
    end)
  end
end
