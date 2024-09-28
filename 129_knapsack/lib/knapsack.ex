defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value([], _maximum_weight), do: 0

  def maximum_value(items, maximum_weight) do
    Enum.sort_by(items, & &1.weight)
    |> knapsack(maximum_weight)
    |> List.flatten()
    |> Enum.max(&>=/2, fn -> 0 end)
  end

  defp knapsack(list, maximum_weight) do
    for size <- 1..length(list) do
      permutations(list, size, {})
      |> List.flatten()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.flat_map(&evaluate_list/1)
      |> Enum.filter(fn {_value, weight} -> weight <= maximum_weight end)
      |> Enum.map(fn {value, _weight} -> value end)
    end
  end

  defp permutations(_, 0, acc), do: acc

  defp permutations(list, size, acc) do
    for {el, i} <- Enum.with_index(list),
        list2 = Enum.slice(list, i..length(list)) -- [el],
        do: permutations(list2, size - 1, Tuple.append(acc, el))
  end

  defp evaluate_list(list) do
    with {result, _} <- Enum.map_reduce(list, {0, 0}, &add_item/2), do: result
  end

  defp add_item(%{value: v, weight: w}, {vt, wt}), do: {{vt + v, wt + w}, {vt + v, wt + w}}
end
