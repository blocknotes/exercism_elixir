defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(""), do: 0

  def count(input) do
    input = process_input(input)
    corners = corners_list(input)
    do_count(input, corners)
  end

  defp do_count(input, corners) do
    Enum.reduce(corners, [], fn {corner, %{same_row: same_row}}, acc ->
      result =
        Enum.reduce(same_row, [], fn corner2, acc2 ->
          result2 =
            Enum.reduce(corners[corner2].same_col, [], fn corner3, acc3 ->
              corner4 =
                Enum.find(corners[corner3].same_row, fn c4 ->
                  corner in corners[c4].same_col
                end)

              rect = [corner, corner2, corner3, corner4]
              if corner4 && valid_rectangle?(input, rect), do: [rect | acc3], else: acc3
            end)

          result2 ++ acc2
        end)

      result ++ acc
    end)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> length()
  end

  defp corners_list(input) do
    corners = Enum.with_index(input) |> extract_corners()

    Enum.reduce(corners, %{}, fn {r, c} = corner, acc ->
      same_row = Enum.filter(corners, fn {r2, _} -> r == r2 end) -- [corner]
      same_col = Enum.filter(corners, fn {_, c2} -> c == c2 end) -- [corner]
      Map.put_new(acc, corner, %{same_row: same_row, same_col: same_col})
    end)
  end

  defp process_input(input) do
    String.split(input, "\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.reject(&(&1 == []))
  end

  defp extract_corners(rows) do
    for {row, r} <- rows, {cell, c} <- Enum.with_index(row), cell == "+", reduce: [] do
      acc -> [{r, c} | acc]
    end
  end

  defp valid_rectangle?(input, rect) do
    result =
      for i <- 0..3, [{r1, c1}, {r2, c2}] = Enum.slice(rect ++ [hd(rect)], i..(i + 1)) do
        valid_side?(input, {r1, c1}, {r2, c2})
      end

    result == [true, true, true, true]
  end

  defp valid_side?(input, {r1, c1}, {r1, c2}) do
    list = for c <- c1..c2, do: get_cell(input, {r1, c})
    Enum.join(list) =~ ~r{\A\+[\-\+]*\+\z}
  end

  defp valid_side?(input, {r1, c1}, {r2, c1}) do
    list = for r <- r1..r2, do: get_cell(input, {r, c1})
    Enum.join(list) =~ ~r{\A\+[|\+]*\+\z}
  end

  defp get_cell(input, {r, c}), do: Enum.at(input, r) |> Enum.at(c)
end
