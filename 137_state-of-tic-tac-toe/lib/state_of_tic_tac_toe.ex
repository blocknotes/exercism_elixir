defmodule StateOfTicTacToe do
  @already_won_error {:error, "Impossible board: game should have ended after the game was won"}
  @o_started_error {:error, "Wrong turn order: O started"}
  @x_went_twice_error {:error, "Wrong turn order: X went twice"}

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    board_error = check_board(board)

    cond do
      board_error -> board_error
      horizontal_win?(board, "X") or horizontal_win?(board, "O") -> {:ok, :win}
      vertical_win?(board, "X") or vertical_win?(board, "O") -> {:ok, :win}
      diagonal_win?(board, "X") or diagonal_win?(board, "O") -> {:ok, :win}
      draw?(board) -> {:ok, :draw}
      ongoing?(board) -> {:ok, :ongoing}
    end
  end

  defp check_board(board) do
    symbols = String.graphemes(board) |> Enum.frequencies()
    x = symbols["X"] || 0
    o = symbols["O"] || 0

    cond do
      x > o + 1 -> @x_went_twice_error
      o > x -> @o_started_error
      horizontal_win?(board, "X") and horizontal_win?(board, "O") -> @already_won_error
      vertical_win?(board, "X") and vertical_win?(board, "O") -> @already_won_error
      true -> nil
    end
  end

  defp horizontal_win?(board, "X"), do: board =~ ~r/XXX/
  defp horizontal_win?(board, "O"), do: board =~ ~r/OOO/

  defp vertical_win?(board, "X"),
    do: board =~ ~r/(X..[\n]{0,1}){3}|(.X.[\n]{0,1}){3}|(..X[\n]{0,1}){3}/

  defp vertical_win?(board, "O"),
    do: board =~ ~r/(O..[\n]{0,1}){3}|(.O.[\n]{0,1}){3}|(..O[\n]{0,1}){3}/

  defp diagonal_win?(board, "X"), do: board =~ ~r/X..\n.X.\n..X|..X\n.X.\nX../
  defp diagonal_win?(board, "O"), do: board =~ ~r/O..\n.O.\n..O|..O\n.O.\nO../

  defp draw?(board), do: board =~ ~r/([XO]{3}\n{0,1}){3}/

  defp ongoing?(board), do: board =~ ~r/\./
end
