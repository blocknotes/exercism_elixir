defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(""), do: []

  def rows(str) do
    {elements, _rows, cols} = parse_string(str)
    Enum.chunk_every(elements, cols)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    {elements, _rows, cols} = parse_string(str)

    elements
    |> Enum.with_index()
    |> Enum.group_by(fn {_, i} -> rem(i, cols) end, fn {el, _} -> el end)
    |> Map.values()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    filter_rows =
      rows(str)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, i} ->
        max = Enum.max(row)

        row
        |> Enum.with_index()
        |> Enum.flat_map(fn {el, j} -> if(el == max, do: [{i + 1, j + 1}], else: []) end)
      end)

    filter_columns =
      columns(str)
      |> Enum.with_index()
      |> Enum.flat_map(fn {column, j} ->
        min = Enum.min(column)

        column
        |> Enum.with_index()
        |> Enum.flat_map(fn {el, i} -> if(el == min, do: [{i + 1, j + 1}], else: []) end)
      end)

    (filter_rows -- filter_rows -- filter_columns) |> Enum.sort()
  end

  defp parse_string(str) do
    elements = String.split(str) |> Enum.map(&String.to_integer/1)
    rows = to_charlist(str) |> row_count()
    cols = length(elements) |> div(rows)
    {elements, rows, cols}
  end

  defp row_count(str), do: Enum.count(str, &(&1 == ?\n)) |> then(&(&1 + 1))
end
