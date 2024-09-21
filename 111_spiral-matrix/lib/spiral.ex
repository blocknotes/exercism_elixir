defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(1), do: [[1]]

  def matrix(dimension) do
    Enum.reduce(0..(dimension - 1), [], fn i, acc ->
      do_traverse(rem(i, 2) == 0, dimension - i, acc)
    end)
    |> Enum.sort_by(fn {x, y, _v} -> {y, x} end)
    |> Enum.map(fn {_, _, v} -> v end)
    |> Enum.chunk_every(dimension)
  end

  defp do_traverse(_neg, length, []) do
    for x <- 1..length, do: {x, 1, x}
  end

  defp do_traverse(neg, length, acc) do
    dir = if neg, do: -1, else: 1
    {x, y, v} = List.last(acc)

    list1 = for i <- 1..length, do: {x, y + i * dir, v + i}
    {x, y, v} = List.last(list1)

    list2 = for i <- 1..length, do: {x - i * dir, y, v + i}
    acc ++ list1 ++ list2
  end
end
