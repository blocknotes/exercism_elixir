defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []

  def primes_to(limit) do
    Enum.to_list(2..limit)
    |> filter_primes(limit, [])
    |> Enum.reverse()
  end

  defp filter_primes([head | tail], limit, acc) do
    list = for n <- head..limit, n * head <= limit, do: n * head
    filter_primes(tail -- list, limit, [head | acc])
  end

  defp filter_primes([], _limit, acc), do: acc
end
