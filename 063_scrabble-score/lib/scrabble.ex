defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.upcase()
    |> to_charlist()
    |> Enum.group_by(& &1)
    |> Enum.reduce(0, fn {l, w}, acc -> acc + letter_score(l) * length(w) end)
  end

  defp letter_score(l) when l in ~c"AEIOULNRST", do: 1
  defp letter_score(l) when l in ~c"DG", do: 2
  defp letter_score(l) when l in ~c"BCMP", do: 3
  defp letter_score(l) when l in ~c"FHVWY", do: 4
  defp letter_score(l) when l in ~c"K", do: 5
  defp letter_score(l) when l in ~c"JX", do: 8
  defp letter_score(l) when l in ~c"QZ", do: 10
  defp letter_score(_), do: 0
end
