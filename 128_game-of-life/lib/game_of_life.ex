defmodule GameOfLife do
  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick(matrix) do
    map_with_index(matrix, fn {row, r} ->
      map_with_index(row, fn {cell, c} ->
        count_ones(matrix, r, c) |> update_cell(cell)
      end)
    end)
  end

  defp map_with_index(map, map_fn), do: Enum.with_index(map) |> Enum.map(map_fn)

  defp count_ones(matrix, r, c) do
    curr_row = Enum.at(matrix, r)
    range = if c > 0, do: (c - 1)..(c + 1), else: 0..(c + 1)
    count = if r > 0, do: Enum.at(matrix, r - 1) |> count_row_ones(range), else: 0
    count = if c > 0, do: count + count_row_ones(curr_row, (c - 1)..(c - 1)), else: count
    count = count + count_row_ones(curr_row, (c + 1)..(c + 1))
    count + (Enum.at(matrix, r + 1) |> count_row_ones(range))
  end

  defp count_row_ones(nil, _range), do: 0
  defp count_row_ones(row, range), do: Enum.slice(row, range) |> Enum.count(&(&1 == 1))

  defp update_cell(2, 1), do: 1
  defp update_cell(3, _cell), do: 1
  defp update_cell(_ones, _cell), do: 0
end
