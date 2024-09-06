defmodule Prime do
  @moduledoc false

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count == 1, do: 2
  def nth(count) when count > 1, do: do_nth(3, count, [2])

  defp do_nth(n, count, primes) do
    primes = if prime?(n, primes), do: primes ++ [n], else: primes
    if length(primes) < count, do: do_nth(n + 1, count, primes), else: List.last(primes)
  end

  defp prime?(n, primes), do: !Enum.any?(primes, fn i -> rem(n, i) == 0 end)
end
