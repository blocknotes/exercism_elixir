defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, size) when size < 1, do: raise(ArgumentError)
  def largest_product("", _size), do: raise(ArgumentError)

  def largest_product(number_string, size) do
    if String.length(number_string) < size, do: raise(ArgumentError)

    calc_products(number_string, size)
    |> Enum.max()
  end

  defp calc_products(number_string, size) do
    for i <- 0..(String.length(number_string) - size),
        part = String.slice(number_string, i, size),
        digits = String.graphemes(part),
        do: Enum.reduce(digits, 1, fn el, acc -> acc * String.to_integer(el) end)
  end
end
