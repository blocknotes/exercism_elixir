defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{size: size, exclude: exclude, sum: sum}) do
    1..Enum.min([sum - size + 1, 9])
    |> Enum.to_list()
    |> Kernel.--(exclude)
    |> do_permutations(size, {})
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.sort()))
    |> Enum.uniq()
    |> Enum.filter(&valid_for_cage?(size, sum, &1))
  end

  defp do_permutations(_, 0, acc), do: acc

  defp do_permutations(list, size, acc) do
    result = for el <- list, do: do_permutations(list -- [el], size - 1, Tuple.append(acc, el))
    List.flatten(result)
  end

  defp valid_for_cage?(size, sum, perm) do
    Enum.sum(perm) == sum and perm |> Enum.uniq() |> length() == size
  end
end
