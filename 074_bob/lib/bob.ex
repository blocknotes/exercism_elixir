defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    cond do
      silence?(input) -> "Fine. Be that way!"
      yelling_question?(input) -> "Calm down, I know what I'm doing!"
      yelling?(input) -> "Whoa, chill out!"
      asking_question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp asking_question?(string), do: string =~ ~r/\?\s*\z/
  defp silence?(string), do: string =~ ~r/\A\s*\z/
  defp yelling?(string), do: string =~ ~r/\pL/ and upcase?(string)
  defp yelling_question?(string), do: string =~ ~r/\pL.*\?\s*\z/ and upcase?(string)
  defp upcase?(string), do: string == String.upcase(string)
end
