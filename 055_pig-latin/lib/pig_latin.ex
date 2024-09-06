defmodule PigLatin do
  @moduledoc false

  @pig_latin_regex ~r/([aeiou].*)|(xr.*)|(yt.*)|([^aeiou]*qu)(.*)|([^aeiou]+)(y.*)|([^aeiou]+)(.*)/

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map_join(" ", &translate_word/1)
  end

  defp translate_word(word) do
    case Regex.run(@pig_latin_regex, word) do
      [_, rule1] -> "#{rule1}ay"
      [_, "", rule1] -> "#{rule1}ay"
      [_, "", "", rule1] -> "#{rule1}ay"
      [_, "", "", "", rule3_pre, rule3_post] -> "#{rule3_post}#{rule3_pre}ay"
      [_, "", "", "", "", "", rule4_pre, rule4_post] -> "#{rule4_post}#{rule4_pre}ay"
      [_, "", "", "", "", "", "", "", rule2_pre, rule2_post] -> "#{rule2_post}#{rule2_pre}ay"
    end
  end
end
