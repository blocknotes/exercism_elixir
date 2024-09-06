defmodule Pangram do
  @moduledoc false

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    count =
      sentence
      |> String.downcase()
      |> String.replace(~r/[^a-z]/, "")
      |> String.codepoints()
      |> Enum.uniq()
      |> length()

    count == 26
  end
end
