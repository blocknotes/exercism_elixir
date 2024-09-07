defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number > 999_999_999_999,
    do: {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    parts = [
      rem(number, 1_000_000_000_000) |> billions(),
      rem(number, 1_000_000_000) |> millions(),
      rem(number, 1_000_000) |> thousands(),
      rem(number, 1_000) |> hundreds(),
      number |> units()
    ]

    {:ok, compact_join(parts)}
  end

  defp billions(number) do
    num = div(number, 1_000_000_000)
    if num == 0, do: nil, else: [hundreds(num), units(num), "billion"] |> compact_join()
  end

  defp millions(number) do
    num = div(number, 1_000_000)
    if num == 0, do: nil, else: [hundreds(num), units(num), "million"] |> compact_join()
  end

  defp thousands(number) do
    num = div(number, 1_000)
    if num == 0, do: nil, else: [hundreds(num), units(num), "thousand"] |> compact_join()
  end

  defp hundreds(number) do
    num = div(number, 100)
    if num == 0, do: nil, else: [units(num), "hundred"] |> compact_join()
  end

  defp units(number) do
    num = rem(number, 100)

    cond do
      num == 0 -> nil
      num <= 19 -> mapping()[num]
      num <= 29 -> compact_join([mapping()[20], mapping()[rem(num, 20)]], "-")
      num <= 39 -> compact_join([mapping()[30], mapping()[rem(num, 30)]], "-")
      num <= 49 -> compact_join([mapping()[40], mapping()[rem(num, 40)]], "-")
      num <= 59 -> compact_join([mapping()[50], mapping()[rem(num, 50)]], "-")
      num <= 69 -> compact_join([mapping()[60], mapping()[rem(num, 60)]], "-")
      num <= 79 -> compact_join([mapping()[70], mapping()[rem(num, 70)]], "-")
      num <= 89 -> compact_join([mapping()[80], mapping()[rem(num, 80)]], "-")
      num <= 99 -> compact_join([mapping()[90], mapping()[rem(num, 90)]], "-")
      true -> nil
    end
  end

  defp mapping do
    %{
      1 => "one",
      2 => "two",
      3 => "three",
      4 => "four",
      5 => "five",
      6 => "six",
      7 => "seven",
      8 => "eight",
      9 => "nine",
      10 => "ten",
      11 => "eleven",
      12 => "twelve",
      13 => "thirteen",
      14 => "fourteen",
      15 => "fifteen",
      16 => "sixteen",
      17 => "seventeen",
      18 => "eighteen",
      19 => "nineteen",
      20 => "twenty",
      30 => "thirty",
      40 => "forty",
      50 => "fifty",
      60 => "sixty",
      70 => "seventy",
      80 => "eighty",
      90 => "ninety"
    }
  end

  defp compact_join(list, joiner \\ " "), do: list |> Enum.reject(&is_nil/1) |> Enum.join(joiner)
end
