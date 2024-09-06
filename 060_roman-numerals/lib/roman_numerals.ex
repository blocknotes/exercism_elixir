defmodule RomanNumerals do
  @moduledoc false

  @mapping %{
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C",
    400 => "CD",
    500 => "D",
    900 => "CM",
    1000 => "M"
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number), do: do_convert({number, ""})

  @mapping
  |> Enum.sort(:desc)
  |> Enum.each(fn {key, value} ->
    defp do_convert({number, acc}) when number >= unquote(key),
      do: do_convert({number - unquote(key), acc <> unquote(value)})
  end)

  defp do_convert({_, acc}), do: acc
end
