defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base_downcase = String.downcase(base)
    base_token = tokenize(base_downcase)

    Enum.filter(candidates, &anagram?(base_token, base_downcase, String.downcase(&1)))
  end

  defp anagram?(_, base_word, word) when base_word == word, do: false
  defp anagram?(base_token, _, word), do: base_token == tokenize(word)

  defp tokenize(word) do
    word
    |> String.to_charlist()
    |> Enum.sort()
  end
end
