defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.replace(~r/[^\w]/, "")
    |> String.downcase()
    |> to_charlist()
    |> then(&(count_unique_letters(&1) == length(&1)))
  end

  defp count_unique_letters(sentence) do
    Enum.uniq(sentence)
    |> length()
  end
end
