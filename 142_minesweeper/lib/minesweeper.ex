defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate([]), do: []
  def annotate([""]), do: [""]

  def annotate(board) do
    Enum.map(board, &String.graphemes/1)
    |> do_annotate()
    |> prepare_result(board)
  end

  defp do_annotate(board) do
    for {row, r} <- Enum.with_index(board), {_v, c} <- Enum.with_index(row) do
      v = mine(board, {r, c})
      update_cell(board, {r, c}, v)
    end
  end

  defp update_cell(_board, _rc, 1), do: "*"

  defp update_cell(board, rc, _v) do
    cnt = count_mines_around(board, rc)
    if cnt > 0, do: to_string(cnt), else: " "
  end

  defp count_mines_around(board, {r, c}) do
    mine(board, {r - 1, c - 1}) + mine(board, {r - 1, c}) + mine(board, {r - 1, c + 1}) +
      mine(board, {r, c - 1}) + mine(board, {r, c + 1}) +
      mine(board, {r + 1, c - 1}) + mine(board, {r + 1, c}) + mine(board, {r + 1, c + 1})
  end

  defp mine(_board, {-1, _c}), do: 0
  defp mine(_board, {_r, -1}), do: 0

  defp mine(board, {r, c}) do
    with row <- Enum.at(board, r),
         do: if(not is_nil(row) and Enum.at(row, c) == "*", do: 1, else: 0)
  end

  defp prepare_result(result, board) do
    columns = List.first(board) |> String.length()
    Enum.chunk_every(result, columns) |> Enum.map(&Enum.join/1)
  end
end
