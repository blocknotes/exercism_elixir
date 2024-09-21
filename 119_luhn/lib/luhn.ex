defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(n), do: !(n =~ ~r/\A\s*0+\s*\z/) and n =~ ~r/\A[\d\s]+\z/ and luhn?(n)

  defp luhn?(number) do
    digits(number)
    |> Enum.reverse()
    |> Enum.chunk_every(2)
    |> Enum.map(&chunk_sum/1)
    |> Enum.sum()
    |> rem(10) == 0
  end

  defp digits(number) do
    number
    |> String.replace(~r/[^\d]/, "")
    |> to_charlist()
    |> Enum.map(&(&1 - ?0))
  end

  defp chunk_sum([a]), do: a
  defp chunk_sum([a, 9]), do: a + 9
  defp chunk_sum([a, b]), do: a + rem(b * 2, 9)
end
