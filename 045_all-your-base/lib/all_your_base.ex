defmodule AllYourBase do
  @moduledoc false

  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, input_base, _) when input_base < 2, do: {:error, "input base must be >= 2"}
  def convert(_, _, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}

  def convert(digits, input_base, output_base) do
    if Enum.any?(digits, &(&1 < 0 or &1 >= input_base)) do
      {:error, "all digits must be >= 0 and < input base"}
    else
      new_digits =
        digits
        |> digits_to_value(input_base)
        |> do_convert(output_base)
        |> Enum.reverse()

      {:ok, new_digits}
    end
  end

  defp digits_to_value(digits, input_base) do
    count = length(digits)

    digits
    |> Stream.with_index()
    |> Enum.reduce(0, fn {d, i}, acc -> acc + d * :math.pow(input_base, count - i - 1) end)
    |> round()
  end

  defp do_convert(value, base) when value < base, do: [value]
  defp do_convert(value, base), do: [rem(value, base) | do_convert(div(value, base), base)]
end
