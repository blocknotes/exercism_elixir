defmodule Connect do
  defstruct data: [], rows: 0, columns: 0

  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    board = prepare_board(board)

    (winning?(board, "X", starting_x(board)) && :black) ||
      (winning?(board, "O", starting_o(board)) && :white) ||
      :none
  end

  defp prepare_board(board) do
    data = Enum.map(board, &String.graphemes/1)
    %Connect{data: data, rows: length(data), columns: List.first(data) |> length()}
  end

  defp starting_x(board) do
    Enum.map(board.data, &hd/1)
    |> Enum.with_index(fn v, i -> {v, {i, 0}} end)
    |> Enum.filter(fn {v, _rc} -> v == "X" end)
    |> Enum.map(fn {_v, rc} -> rc end)
  end

  defp starting_o(board) do
    List.first(board.data)
    |> Enum.with_index(fn v, i -> {v, {0, i}} end)
    |> Enum.filter(fn {v, _rc} -> v == "O" end)
    |> Enum.map(fn {_v, rc} -> rc end)
  end

  defp winning?(board, symbol, starting),
    do: Enum.find(starting, false, &winning_path?(board, symbol, &1, []))

  defp winning_path?(board, "X", {_r, c}, _traversed) when c == board.columns - 1, do: true
  defp winning_path?(board, "O", {r, _c}, _traversed) when r == board.rows - 1, do: true

  defp winning_path?(board, symbol, rc, traversed) do
    rc not in traversed and
      matching_neighbors(board, symbol, rc)
      |> Enum.find(false, &winning_path?(board, symbol, &1, [rc | traversed]))
  end

  defp matching_neighbors(board, symbol, {r, c}) do
    list = []
    list = if matching?(board, symbol, {r, c - 1}), do: [{r, c - 1} | list], else: list
    list = if matching?(board, symbol, {r - 1, c}), do: [{r - 1, c} | list], else: list
    list = if matching?(board, symbol, {r - 1, c + 1}), do: [{r - 1, c + 1} | list], else: list
    list = if matching?(board, symbol, {r, c + 1}), do: [{r, c + 1} | list], else: list
    list = if matching?(board, symbol, {r + 1, c}), do: [{r + 1, c} | list], else: list
    list = if matching?(board, symbol, {r + 1, c - 1}), do: [{r + 1, c - 1} | list], else: list
    list
  end

  defp matching?(board, symbol, {r, c}) do
    if r >= 0 and c >= 0 and r < board.rows and c < board.columns,
      do: Enum.at(board.data, r) |> Enum.at(c) == symbol,
      else: false
  end
end
