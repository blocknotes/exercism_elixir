defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.split(~r/[\s_,.:;!&@$%^]/)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.replace(&1, ~r/\A'|'\z/, ""))
    |> Enum.frequencies()
  end
end
