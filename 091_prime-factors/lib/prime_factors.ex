defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factors(1, number, []) |> Enum.reverse()

  defp factors(_, 1, acc), do: acc
  defp factors(1, j, acc), do: factors(2, j, acc)
  defp factors(i, j, acc) when rem(j, i) == 0, do: factors(i, div(j, i), [i | acc])
  defp factors(i, j, acc) when i <= j, do: factors(i + 1, j, acc)
end
