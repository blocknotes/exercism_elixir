defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    with {result, _} <- prepare_rows(num), do: result
  end

  defp prepare_rows(num) do
    Enum.map_reduce(0..(num - 1), [], fn _, acc ->
      row = prepare_row(acc)
      {row, row}
    end)
  end

  defp prepare_row([]), do: [1]

  defp prepare_row(prev_row) do
    Enum.map_reduce(prev_row, 0, fn el, acc -> {acc + el, el} end)
    |> Tuple.to_list()
    |> List.flatten()
  end
end
