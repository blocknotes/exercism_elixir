defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    Enum.map(factors, &multiples(limit, &1))
    |> Enum.concat()
    |> Enum.uniq()
    |> List.delete(limit)
    |> Enum.sum()
  end

  defp multiples(_n, 0), do: []
  defp multiples(n, factor) when factor > n, do: []

  defp multiples(n, factor) do
    for i <- 1..div(n, factor), do: i * factor
  end
end
